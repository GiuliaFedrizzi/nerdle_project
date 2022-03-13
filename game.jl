function main()
    attempts=0
    valid_expr = false   # have you provided a valid expression?
    solution="31+12=43"
    println("the solution is: ", solution)
    # print("-> give me an expression:   ")
    input = 0
    # if input ==solution
    #     println("how the heck did you get it in 1 attempt??")
    # end
    while (input !=solution)
        #println("You entered: ",input,", this is not the solution. Checking if it's valid...")
        while (!valid_expr)
            print("-> give me an expression:   ")
            input = readline()  # try again !
            # ****************************************************************
            #                       do the checks
            # ****************************************************************
            valid_expr = checkProvidedInput(input) # call function that does the checks
            if valid_expr
                attempts+=1  # if everythig is ok, increase the counter
                #println("That's valid! incrementing attempts.")
            else
                println("Sorry, that was not valid.")
                #input = readline()  # try again !
            end
        end
        print("You tried ",attempts," time(s). ")
        #input = readline()  # try again !
        if input !=solution
            valid_expr=false   # reset default to false so I can enter the !valid_expr loop again
            print("Not Correct. Try again. ")
        end
    end # end of while (input !=solution)
    #if attempts!=0; println("you got it in ",attempts," attempts!"); end
    println("You guessed! Well done!")
end    # end of main()



function checkProvidedInput(input)
    valid_expr=true  # on the first failed test, valid_expr will be set to false
    if length(input)!=8
        println("Wrong number of input characters")
        valid_expr = false
    elseif !occursin(r"(^[^=]+=[^=]+$)", input) 
        println("Invalid expression: equals sign either not provided or in the wrong place")
        valid_expr = false
    
    end

    try    # try if you can 1. split with '=' and 2. do maths with the provided characters
        lhs,rhs=split(input, "="; limit=2)    # Splitting it into left hand side (lhs) and right hand side (rhs) - (only once)
        lhs_parsed=Meta.parse(lhs)
        rhs_parsed=Meta.parse(rhs)
        lhs_result=eval(lhs_parsed)
        if occursin(r"([^0-9.])", rhs)  # search for non-numeric in rhs (can only be a number)
            println("there are non-numeric characters after the equals sign.")
            valid_expxr = false
        elseif !occursin(r"(^[0-9+\-*\/=]+$)",lhs)
            println("Invalid expression: allowed characters are numbers and +,-,*,/")
            valid_expr = false
        elseif rhs_parsed != lhs_result  # does the provided lhs match rhs?
            println("you can't do maths -.-' ")
            valid_expr = false
        end
    catch
        println("that doesn't look like maths to me")
        valid_expr = false
        # println("length of lhs is ",length(lhs), ", its components are:")
        # for i = 1:length(lhs)
        #     println(lhs[i])
        # end
        # println("The result is: ",lhs_result)
    end
    return valid_expr # let the main function know if the expression is ok or not
end

main()
