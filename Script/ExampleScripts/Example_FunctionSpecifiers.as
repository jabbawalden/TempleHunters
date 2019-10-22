class AExampleFunctionSpecifierActor : AActor
{
    /* 
        When declaring functions, Function Specifiers can be added to the declaration to control how the function behaves with various aspects of the Engine and Editor.
    */

    // Adding UFUNCTION allows the function to be visible in blueprint, as a non-pure function
    UFUNCTION()
    void BlueprintVisibleFunction()
    {
    }

    /*  BlueprintPure turns the function into a pure function
    *   Pure functions require a return value, for obvious reasons 
    */
    UFUNCTION(BlueprintPure)
    bool BlueprintPureFunction()
    {   
        return true;     
    }

    // BlueprintEvent allows this function to be overridden in blueprint.
    //   Note that the function will not be callable from blueprint, only overridable,
    //   unless you also specify BlueprintCallable in the specifiers.
    UFUNCTION(BlueprintEvent)
    void BlueprintEventFunction()
    {
    }

    // You can also categorize your functions, same as BP
    UFUNCTION(Category = "Really Cool Category")
    void CategorizedFunction()
    {
    }

    // You can chain specifiers together in a single function, using a comma to separate specifiers
    UFUNCTION(BlueprintPure, BlueprintEvent, Category = "Hi Mum")
    int ReallySpecifiedFunction()
    {
        return 1337;
    }

    /*  BlueprintOverride overrides the C++ function.
    *   Includes functions such as Tick, BeginPlay, ConstructionScript etc
    */ 
    UFUNCTION(BlueprintOverride) 
    void Tick(float DeltaTime)
    {        
    }    
}