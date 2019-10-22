/*
 * Script classes can always derive from the same classes that
 * blueprints can be derived from.
 */


// For example, we can make a new Actor class
class AExampleActorType : AActor
{
	/* Any class variables declared as UPROPERTY() will be
	 * accessible to be set in levels on the actor. */
	UPROPERTY()
	int ExampleValue = 15;

	/* Use the 'default' keyword to override property defaults from the parent class. */
	default bReplicates = true;
	default Tags.Add(n"ExampleTag");

	/* 
	 * Methods in the class declared with UFUNCTION() above them
	 * will automatically be callable from blueprint on instances of this class.
	 */
	UFUNCTION()
	void BlueprintAccessibleMethod()
	{
		Log("BlueprintAccessibleMethod Called");
	}

	/*
	 * Methods without UFUNCTION() will only be usable from script.
	 *  Since unreal does not need to know about them, hot reloading them
	 *  can occur significantly faster than when a UFUNCTION() changes.
	 */
	void ScriptOnlyMethod()
	{
		Log("ScriptOnlyMethod Called");
	}

	/*
	 * Sometimes, rather than creating a new function, you want to
	 * override a function in a C++ parent class, such as BeginPlay.
	 * This requires marking the method as BlueprintOverride.
	 *
	 * BlueprintOverride works on C++ methods that are declared either
	 * BlueprintImplementEvent or BlueprintNativeEvent. There is no
	 * difference in script between the two.
	 */
	UFUNCTION(BlueprintOverride)
	void BeginPlay()
	{
		// Call our ScriptOnlyMethod first
		ScriptOnlyMethod();

		// Call the method declared below when BeginPlay happens
		NewOverridableMethod();
	}

	/* 
	 * In order to declare a new event that can be overriden by
	 * blueprints deriving from this script class, we can use the
	 * BlueprintEvent specifier on the method.
	 *
	 * Note that there is no ImplementableEvent/NativeEvent difference
	 * here either. The script method will be called as a default if
	 * there is no blueprint override, otherwise the blueprint method will
	 * be called.
	 */
	 
	UFUNCTION(BlueprintEvent)
	void NewOverridableMethod()
	{
		Log("Blueprint did not override this event.");
	}
};