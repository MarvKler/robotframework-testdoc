*** Settings ***
Documentation    Exercises control-flow syntax (FOR/IF/WHILE/TRY) for parser coverage.


*** Test Cases ***
Control Flow Demo
    [Documentation]    Exercises FOR, IF/ELSE, WHILE, BREAK, CONTINUE and TRY/EXCEPT/FINALLY.
    ${counter} =    Set Variable    ${0}
    FOR    ${i}    IN RANGE    3
        IF    ${i} == 1
            CONTINUE
        ELSE IF    ${i} == 2
            BREAK
        ELSE
            Log    Iteration ${i}
        END
    END
    WHILE    $counter < 1
        Log    Looping
        ${counter} =    Evaluate    ${counter} + 1
    END
    TRY
        Log    Risky operation
    EXCEPT    Some Error
        Log    Handled error
    FINALLY
        Log    Cleanup
    END
