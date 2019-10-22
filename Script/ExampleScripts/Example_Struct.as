/* 
 * All structs are automatically bound to unreal and can
 * be used without further ado.
 *
 * Note that for technical reasons changing any properties
 * in a struct requires a full reload, regardless of whether
 * they are UPROPERTY() or not.
 */
struct FExampleStruct
{
	/* Properties with UPROPERTY() in a struct will be accessible in blueprint. */
	UPROPERTY()
	float ExampleNumber = 4.f;

	UPROPERTY()
	FString ExampleString = "Example String";

	/* Properties without UPROPERTY() will still be in the struct, but cannot be seen by blueprint. */
	float ExampleHiddenNumber = 3.f;
};

/* Structs can be used as properties in classes, or as arguments to functions. */
class AExampleStructActor : AActor
{
	UPROPERTY()
	FExampleStruct ExampleStruct;

	UFUNCTION(BlueprintOverride)
	void BeginPlay()
	{
		Print(ExampleStruct.ExampleString+", "+ExampleStruct.ExampleNumber);
	}

	/* Structs from C++ can of course be used as well. */
	UPROPERTY()
	FHitResult ExampleHitResult;
};