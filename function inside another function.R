An advantage of using a function inside another function is Decoration. Decorators are a very powerful and useful tool since it allows programmers to modify the behaviour of a function. we can modify a function by wrapping it inside another function that add some functionality to it. By definition, a decorator is a function that takes another function as an argument and extends the behavior of the latter function without explicitly modifying it. 


Consider we have two simple function:

    
    add<-function(a,b){
      Sys.sleep(2)
      return(a+b)
    }
    
    mult<-function(a,b,c,d){
      Sys.sleep(3)
      return(a*b*c*d)
    }

And we want to extend their behaviors. For example how many time they called, when started and  show a message when finished.

We can create a decorator function that make it happen as follows:

    counter <- function(fn) {
      force(fn)
      cnt <- 0
      inner <- function(...) {
        cnt <<- cnt + 1
        message(sprintf(
          "Function %s was called %s times",
          as.character(match.call()[[1]]),
          cnt
        ))
        message(paste("\n The Function started at:", "\n ", Sys.time(), "\n"))
        on.exit({
          message(paste("\n The Function finished at:", Sys.time(), "\n "))
          
        })
        return(fn(...))
      }
      return(inner)
      
    }

Now we can extend the functions by the decorator function(just one function for both) as follows:

    add<-counter(add)
    mult<-counter(mult)

Now we can use extended functions:

    > add(1,2)
    Function add was called 1 times
    
     The Function started at: 
      2022-09-27 00:26:41 
    
    
     The Function finished at: 2022-09-27 00:26:43 
     
    [1] 3
    > add(3,3)
    Function add was called 2 times
    
     The Function started at: 
      2022-09-27 00:26:43 
    
    
     The Function finished at: 2022-09-27 00:26:45 
     
    [1] 6
    > mult(1,1,2,3)
    Function mult was called 1 times
    
     The Function started at: 
      2022-09-27 00:26:45 
    
    
     The Function finished at: 2022-09-27 00:26:48 
     
    [1] 6


It does not need to know the number of parameters, just decorate them! counter is a decorator. The decorator function, 'counter', modified a function and extend it. 

For more example we want to cache the restuls of a calculation to avoid repeating it in future. 



    factorial2<-function(n){
      message(paste0("Calculating ",n,"!"))
      return(factorial(n))
    }
    cache<-function(fn){
      invisible(force(fn))
      cache_memory<- list("0"=1,"1" = 1, "2" = 2)
      inner<-function(n){
        if(!(as.character(n) %in% names(cache_memory))){
          cache_memory[[as.character(n)]]<<-fn(n)
          return(fn(n))
        }else{
          return(cache_memory[[as.character(n)]])
        }
      }
      return(inner)
    }
    factorial2<-cache(factorial2)
    > factorial2(0)
    [1] 1
    > factorial2(1)
    [1] 1
    > factorial2(2)
    [1] 2
    > factorial2(3)
    Calculating 3!
    Calculating 3!
    [1] 6
    > factorial2(3)
    [1] 6
    > factorial2(30)
    Calculating 30!   #calculate 30!
    Calculating 30!
    [1] 2.652529e+32      # the cache used 
    > factorial2(30)
    [1] 2.652529e+32      # the cache used 

