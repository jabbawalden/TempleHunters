
/*
 * In this example we will trace lines in the world on BeginPlay
 */

class ATracelineExampleActor : AActor
{
	UFUNCTION(BlueprintOverride)
	void BeginPlay()
	{
		
		/* We create this array in order to add Actors to be ignored */
		TArray<AActor> IgnoredActors;
		IgnoredActors.Add(GetOwner());
		IgnoredActors.Add(this);

		FVector StartLocation = ActorLocation;
		FVector EndLocation = ActorLocation + (GetActorForwardVector() * 1000.0f);


		/* We use this FHitResult to store our line tracing results */
		FHitResult Hit;
		if(System::LineTraceSingle(StartLocation, EndLocation, ETraceTypeQuery::Visibility, true, IgnoredActors, EDrawDebugTrace::None, Hit, true))
		{
			AActor HitActor = Hit.GetActor();

			//Debug to help you visualize the linetrace
			Print("An Actor was Hit: " + HitActor.Name, 2.0f);
			System::DrawDebugLine(StartLocation, EndLocation, FLinearColor::Green, 5.0f, 2.0f);
		}
	}
}