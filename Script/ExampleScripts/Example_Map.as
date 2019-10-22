/*
 * TMap<KeyType,ValueType> is used to store a key->value lookup table,
 * this works similar to C++ TMap<>, with a few small differences
 * because there are no pointers in angelscript.
 */
UFUNCTION()
void ExecuteExampleMap()
{
	// A local variable holding a map.
	TMap<FString, int> LocalStringToIntMap;

	// Adds an association between a specific string and its integer.
	LocalStringToIntMap.Add("TestString", 2);
	LocalStringToIntMap.Add("Three", 3);
	LocalStringToIntMap.Add("Four", 4);

	// Check whether the given key has anything associated with it
	if (!LocalStringToIntMap.Contains("TestString"))
	{
		Throw("Map did not contain TestString.");
	}

	// Find() returns whether a value with that key was found,
	// if it was, then the value is copied into the passed value.
	int FoundValue = -1;
	if (!LocalStringToIntMap.Find("Four", FoundValue))
	{
		Throw("Map did not contain Four.");
	}

	// FoundValue is now 4, since Find() sets the value it gets passed.
	if (FoundValue != 4)
	{
		Throw("Map contained wrong value for Four.");
	}

	// Looping over elements can be done with a range-based loop.
	//  Note that the type of auto here is an iterator type,
	//  which supports access to .Key and .Value.
	for (auto Element : LocalStringToIntMap)
	{
		Log("Map contained "+Element.Key+" => "+Element.Value);
	}

	// Remove everything from the map that was in there
	LocalStringToIntMap.Empty();
}

/*
 * Example of a TMap<> added as a UPROPERTY().
 *  This will let you select actors from the level
 *  to associate strings with.
 */
class AExampleMapActor : AActor
{
	UPROPERTY()
	TMap<AActor, FString> ActorMap;

	UFUNCTION()
	void PrintActorMap()
	{
		// Range based for loop to iterate all elements
		for (auto Element : ActorMap)
		{
			Log("Actor Map: "+Element.Key+" => "+Element.Value);
		}
	}
};