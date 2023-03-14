"""
Nerdle game!
The user gives a (valid) mathematical expression as input, the code gives hints back until the user guesses.
- '*' = the character is in the solution and in the right place
- 'o' = the character is in the solution but not in the right place
- '-' = the character is not in the solution
"""
function main()
    attempts=0
    valid_expr = false   # have you provided a valid expression?
    solution="31+12=43"  # temporarily specify it here
    println("the solution is: ", solution)
    # print("-> give me an expression:   ")
    input = 0

    while (input !=solution)
        """
        keep going until the input matches the solution
        """
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
            giveHints(input,solution)
            #print("Not Correct. Try again. ")
        end
    end # end of while (input !=solution)
    #if attempts!=0; println("you got it in ",attempts," attempts!"); end
    println("You guessed! Well done!")
end    # end of main()


"""
Check that the input expression is valid
"""
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
        lhs,rhs=split(input, "="; limit=2)    # Splitting it into left hand side (lhs) and right hand side (rhs) - (limit=2 means only once)
        lhs_parsed=Meta.parse(lhs)
        rhs_parsed=Meta.parse(rhs)
        lhs_result=eval(lhs_parsed)
        if occursin(r"([^0-9.])", rhs)  # search for non-numeric in rhs (can only be a number)
            println("there are non-numeric characters after the equals sign.")
            valid_expr = false
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
    end
    return valid_expr # let the main function know if the expression is ok or not
end


"""
Based on the user's guess, give hints for each character in the guess.

TO DO:
   if hint about a character was already given, don't do it again unless there's another one.
   i.e. if n of same character in guess > n of that same character in answer, skip
"""
function giveHints(input,solution)
    input_array=split(input,"")    # get the input into the form of an array
    solution_array=split(solution,"")   # get the solution into the form of an array
    hint_sequence=[]   # initialise the sequence that will store the hints
    # for i = 1:length(input_array)  # go through all elements
    for (i, guess) in enumerate(input_array)  # go through elements of guess, one by one
        indexes=findall(x->x==guess, solution_array)
        correct=solution_array[i]  # the correct character that should be in that position
        if guess==correct          
            append!(hint_sequence,'*')    # if the guess matched, append a star.
        elseif !isempty(indexes)
            append!(hint_sequence,'o')    # if the guess occurs somewhere else, append an 'o'.
        else
            append!(hint_sequence,'-')    # if the guess occurs doesn't occur, append a '-'.
        end
    end
    println(hint_sequence)
end


# execute:
main()
