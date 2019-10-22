class ATREnvironmentPiece : AActor
{
    //Sets mesh
    UPROPERTY(DefaultComponent, RootComponent)
    UStaticMeshComponent MeshComp;

    UPROPERTY()
    //Default Material
    UMaterial DefaultMat;

    UPROPERTY()
    //Transluscent Material (very light and see through)
    UMaterial TransluscentMat;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        MeshComp.SetMaterial(0, DefaultMat); 
    }
    
    //Function that sets material to transluscent
    UFUNCTION()
    void SetTransluscentMaterial()
    {
        MeshComp.SetMaterial(0, TransluscentMat); 
    } 

    //Function that sets material back to normal
    UFUNCTION()
    void SetDefaultMaterial()
    {
        MeshComp.SetMaterial(0, DefaultMat); 
    }

    
}