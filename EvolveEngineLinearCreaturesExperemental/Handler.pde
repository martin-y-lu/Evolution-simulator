void ResetEnv(){
  if(EnvNumber!=PastEnvs.size()-1){
    EnvNumber=PastEnvs.size()-1;
    //Env=PastEnvs.get(EnvNumber);
  }
}
void SetEnv(int Number){
  EnvNumber=Number;
  Env=PastEnvs.get(EnvNumber).CloneEnv();
  Env.ReshiftToTest();
}
void AddEnv(Enviroment NewEnv){
  int ArchivePoint=1;
  PastEnvs.add(NewEnv.CloneEnv());
  EnvNumber=PastEnvs.size()-1;
  int ArchInd=PastEnvs.size()-1-ArchivePoint;
  if(ArchInd>=0){
    PastEnvs.set(ArchInd,PastEnvs.get(ArchInd).StoreEnv());
  }
  //PastEnvs.get(EnvNumber).ReshiftToTest();
}