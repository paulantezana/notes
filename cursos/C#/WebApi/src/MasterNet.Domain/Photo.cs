namespace MasterNet.Domain;

public class Photo : BaseEntity
{
    public string? Url {get;set;}
    
    public Guid? CursoId {get;set;}
    public Curso? Curso {get;set;}

}