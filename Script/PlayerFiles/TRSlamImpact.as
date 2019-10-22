class ATRSlamImpact : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    USphereComponent SphereComp;
    default SphereComp.SetSphereRadius(300.f); 
    default SphereComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap);

    UPROPERTY(DefaultComponent, Attach = SphereComp)
    UStaticMeshComponent SphereMesh;
    default SphereMesh.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        SphereComp.OnComponentBeginOverlap.AddUFunction(this, n"TriggerOnBeginOverlap");
        FTimerHandle DestroyTime = System::SetTimer(this, n"DestroySlam", 0.25f, false); 
        //spawn particle fx
    }

    UFUNCTION()
    void TriggerOnBeginOverlap(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex, 
        bool bFromSweep, FHitResult& Hit) 
    {
        //if other actor is an enemy, stun them - do via a damage component?
    }

    UFUNCTION()
    void DestroySlam()
    {
        this.DestroyActor(); 
    }
}