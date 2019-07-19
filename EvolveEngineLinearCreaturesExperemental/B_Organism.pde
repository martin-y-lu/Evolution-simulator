String SpeciesName(int[]Number){
   return "S"+Number[0]+"-"+Number[1]+"-"+Number[2]+"-"+Number[3];
}
int[] SpeciesNum(String Name){
  String[] NumS= split(Name.substring(1),"-");
  int[] Numb = new int[NumS.length];
  for(int i=0;i<NumS.length;i++){
    Numb[i]=Integer.parseInt(NumS[i]);
  }
  return Numb;
}
color SpeciesColor(int[] Number){
  colorMode(HSB,100,255,255,255);
  color C=color(100*(float(Number[0])/6.0+float(Number[1])/60.0),200+255*(Number[3]-3)/20.0,255-255*(Number[2]-3)/40.0);
  //print("color "+(100*(float(Number[0])/6.0+float(Number[1])/60.0)));
  colorMode(RGB,255,255,255,255);
  return C;
}
class Organism{ 
  ArrayList<Point> PList= new ArrayList<Point>();
  ArrayList<Muscle> MList=new ArrayList<Muscle>();
  ArrayList<Nerve> NList=new ArrayList<Nerve>();
  float MuteAmount=1;//The rate of mutation for the organism
  Enviroment E;// Enviroment given to Organism . Organisms can exist without them but dont really function
  /* Essencial functions- Makes the organism run.
     These things do all of the updadating, calculating,displaying, and so on in a organism. 
  */
  int[] SpeciesNumber(){
    int NumEyes=0;
    for(int i=0; i<PList.size();i++){
      if(PList.get(i) instanceof Eye){
        NumEyes++;
      }
    }
    int[] Number={PList.size()-NumEyes,NumEyes,MList.size(),NList.size()};
    return Number;// NumPoints, Num Eyes,Num Muscles, Num neu
  }
  String Name(){
   return SpeciesName(SpeciesNumber());
  }
  void SetVars(){ //Sets the muscles and Nerves.
     SetMuscles();
     SetNerves();
  }
  void SetMuscles(){// Lets muscle know what its Points and Organism is
    for(int m= 0;m<MList.size();m++){
      Muscle M= MList.get(m);
      M.O=this;
      M.SetPois();
    }
  }
  void SetNerves(){// Gives Nerve necicary info
    for(int n= 0;n<NList.size();n++){
      Nerve N= NList.get(n);
      N.C=this;
      N.SetPois();
    }
  }
  void PointsFindState(){// Sets the states of the eyes
    //for(int p=0;p<PList.size();p++){
    //  Point Poi=PList.get(p);
    //  if(Poi instanceof Eye){
    //    Poi.State=E.InGround(Poi);
    //  }
    //}
  }
  void PropogateNerves(){// Sends the signals forward, and Calculates new signal (CalcSetPois)
     for(int p=0;p<PList.size();p++){// Sets all Inputs given back to 0
      Point P=PList.get(p);
      if(P.Type=="Input"){// If Eye, find state;
        //P.State=E.InGround(P)? -1:1;
        ((Eye)P).SetState(E);
      }else{
        P.Inputs=P.UncheckedIn;
        P.InputsUsed=0;
      }
    }
    for(int m=0;m<MList.size();m++){
      Muscle M=MList.get(m);
       M.Inputs=M.UncheckedIn;
       M.InputsUsed=0;
    }
    for(int n=0;n<NList.size();n++){//Shifts inputs, sets first to current state;
      Nerve N= NList.get(n);
      for(int s=1;s<N.StateList.length;s++){
          N.StateList[N.StateList.length-s]=N.StateList[N.StateList.length-s-1];    
      }
      N.StateList[0]=N.I.State;
      // Update states
      //if(N.O.UncheckedIn.length<=N.O.InputsUsed){//If not big enougth
      if( N.O.Type!="Input"){
        N.O.Inputs=expand(N.O.Inputs,N.O.InputsUsed+1); // Add to imputs.
        N.O.Inputs[N.O.InputsUsed]=N.StateList[N.Delay];
        N.O.InputsUsed++;
      }
    }
    CalcSetPois();
  }
  void CalcSetPois(){// Sets the State of logics after reciving inputs
    for(int p=0;p<PList.size();p++){
      Point P=PList.get(p);
        P.CalcState();
        //If weights is not up to size, make it
        if(P.Weights.length<P.InputsUsed){
          P.Weights=expand(P.Weights,P.InputsUsed);
        }
    }
    for(int m=0;m<MList.size();m++){
      Muscle M=MList.get(m);
      M.CalcState();
    }
  }
  void CalcNerves(){// fully sets and propogates states
   // PointsFindState();
    PropogateNerves();
  }
  void UpdatePois(){// Updates positions, forces of particeles and muscles
    for(int m=0;m<MList.size();m++){
      Muscle Musc =MList.get(m);
      Musc.CalcForce();
    }
    for(int p=0;p<PList.size();p++){
      Point Poi=PList.get(p);
      if(Poi.Type!="Input"){// I DONT CAL IT EXPEREMENTAL FOR NOTHING
        //for(int num=0;(E.NumColliding(Poi)>0)&&(num<=E.NumColliding(Poi)+2);num++){// RUNS THROU BARRIERS, checks if any is colliding or too many are colliding
          //if(num>E.NumColliding(Poi)+1){
          //  Poi.Acc=new PVector(0,0);//STABLEISE
          //  Poi.Vel=new PVector(0,0);
          //}
          for(int o=0;o<E.BList.size();o++){
            Barrier B=E.BList.get(o);
            B.CheckColl(Poi);// CALC COLL
          }                                      // SHOULD BE IN ENV??
        //}    
      }
      Poi.UpdateP();
    }
  }
  void DrawO(Camera Cam, PGraphics Canvas){// Draws all things in an organism
    for(int m=0;m<MList.size();m++){
      Muscle Musc =MList.get(m);
      fill(255);
      Musc.DrawM(Cam,Canvas);
    }
    for(int n= 0;n<NList.size();n++){
      Nerve N= NList.get(n);
      N.DrawNerve(Cam,Canvas);
    }
    for(int p=0;p<PList.size();p++){
      Point Poi=PList.get(p);
      fill(255);
      Poi.DrawP(Cam,Canvas);
    }
  }
  /*Useful Manipulations- Lets you change shtuff
    Does all kinds of things, adds points,deletes points...  Essensial functions for evolution are here.
 */
  Organism CloneOrganism(){// Returns Copy of organism.  ORGANISM NOT GIVEN ENVIROMENT]
    Organism Org = new Organism();
    Org.MuteAmount=MuteAmount;
    for(int p=0;p<PList.size();p++){
      Point P=PList.get(p);
      Org.PList.add(P.ClonePoint());
    }
   for(int m= 0;m<MList.size();m++){
      Muscle M= MList.get(m);
      Org.MList.add(M.CloneMuscle());
      Org.MList.get(m).O= Org;
      Org.MList.get(m).SetPois();
    }
    for(int n= 0;n<NList.size();n++){
      Nerve Neu= NList.get(n);
      Org.NList.add(Neu.CloneNerve());
      Org.NList.get(n).C= Org;
      Org.NList.get(n).SetPois();
    }
    return Org;
  }
  void MutateOrg(){
    MuteAmount+=randomGaussian()*0.06;
    int NumPoiRemoved=abs(round(MuteAmount*randomGaussian()*0.26));
    for(int r=0;r<NumPoiRemoved;r++){
      if(PList.size()>0){
        RemovePoi(randomInt(0,PList.size()-1));
      }
    }
    int NumPoiAdded=abs(round(MuteAmount*randomGaussian()*0.265));
    for(int a=0;a<NumPoiAdded;a++){
      //AddNewPoi();
      AddNewConnectedPoi();
    }
    int NumMuscRemoved=abs(round(MuteAmount*randomGaussian()*0.25));
    for(int rm=0;rm<NumMuscRemoved;rm++){
      if(MList.size()>0){
        RemoveMusc(randomInt(0,MList.size()-1));
      }
    }
    int NumMuscAdded=abs(round(MuteAmount*randomGaussian()*0.3));
    for(int am=0;am<NumMuscAdded;am++){
      AddNewMusc();
    }
    int NumNeuRemoved=abs(round(MuteAmount*randomGaussian()*0.28));
    for(int rn=0;rn<NumNeuRemoved;rn++){
      if(NList.size()>0){
        RemoveNeu(randomInt(0,NList.size()-1));
      }
    }
    int NumNeuAdded=abs(round(MuteAmount*randomGaussian()*0.3));
    for(int an=0;an<NumNeuAdded;an++){
      AddNewNeu();
    }
    for(int p=0;p<PList.size();p++){
      MutatePoi(p);
    }

    for(int m=0;m<MList.size();m++){
      MutateMusc(m);
    }

    for(int n=0;n<NList.size();n++){
      MutateNeu(n);
    }
    
    FixSmarts();
  }
  void FixSmarts(){//Makes sure weights array is up to size
    for(int p=0;p<PList.size();p++){// Sets all Inputs given back to 0
      Point P=PList.get(p);
      if(P.Type!="Input"){
        P.InputsUsed=0;
      }else{
        P.InputsUsed=((Eye)P).EyeRays.size();
      }
    }
    for(int m=0;m<MList.size();m++){
      Muscle M=MList.get(m);
       M.InputsUsed=0;
    }
    for(int n=0;n<NList.size();n++){//Shifts inputs, sets first to current state;
      Nerve N= NList.get(n);
      if( N.O.Type!="Input"){
        N.O.InputsUsed++;
      }
    }
    for(int p=0;p<PList.size();p++){
      Point P=PList.get(p);
      //If weights is not up to size, make it
      if(P.Weights.length<=P.InputsUsed){
        int prevSize=P.Weights.length;
        P.Weights=expand(P.Weights,P.InputsUsed+1);
       if(P.Type=="Input"){
          for(int i=prevSize;i<P.Weights.length;i++){
            P.Weights[i]=randomGaussian()*0.1;
          }
        }else{
          for(int i=prevSize;i<P.Weights.length;i++){
            P.Weights[i]=randomGaussian()*0.2;
          }
        }
      }
    }
     for(int m=0;m<MList.size();m++){
      Muscle M=MList.get(m);
      //If weights is not up to size, make it
      if(M.Weights.length<M.InputsUsed){
        int prevSize=M.Weights.length;
        M.Weights=expand(M.Weights,M.InputsUsed);
        for(int i=prevSize;i<M.Weights.length;i++){
          M.Weights[i]= randomGaussian()*0.2;
        }
      }
    }
  }
  void FixNewOrg(){
    for(int p=0;p<PList.size();p++){// Sets all Inputs given back to 0
      Point P=PList.get(p);
      if(P.Type!="Input"){
        P.InputsUsed=0;
      }else{
        P.InputsUsed=((Eye)P).EyeRays.size();
      }
    }
    for(int m=0;m<MList.size();m++){
      Muscle M=MList.get(m);
       M.InputsUsed=0;
    }
    for(int n=0;n<NList.size();n++){//Shifts inputs, sets first to current state;
      Nerve N= NList.get(n);
      if( N.O.Type!="Input"){
        N.O.InputsUsed++;
      }
    }
    for(int p=0;p<PList.size();p++){
      Point P=PList.get(p);
      //If weights is not up to size, make it
      if(P.Weights.length<=P.InputsUsed){
        int prevSize=P.Weights.length;
        P.Weights=expand(P.Weights,P.InputsUsed+1);
        if(P.Type=="Input"){
          for(int i=prevSize;i<P.Weights.length;i++){
            P.Weights[i]=randomGaussian()*8.0;
          }
        }else{
          int plus=0;
          int minus=0;
          for(int i=prevSize;i<P.Weights.length;i++){
            if(random(1)>0.5){
              P.Weights[i]=10; //randomGaussian()*15.0;
              plus++;
            }else{
              P.Weights[i]=-10; //randomGaussian()*15.0;
              minus++;
            }
          }
          int NumRequired= randomInt(-minus,plus);
          P.Bias=-NumRequired*10.0/2;
        }
      }
    }
     for(int m=0;m<MList.size();m++){
      Muscle M=MList.get(m);
      //If weights is not up to size, make it
      if(M.Weights.length<M.InputsUsed){
        int prevSize=M.Weights.length;
        M.Weights=expand(M.Weights,M.InputsUsed);
        for(int i=prevSize;i<M.Weights.length;i++){
          M.Weights[i]=10;// randomGaussian()*15.0;
        }
        int NumRequired= min(floor(abs(randomGaussian()*3)),M.InputsUsed);
        M.Bias=-NumRequired*10.0/2;
      }
    }
  }
  
  void GenNewPoi(){ //Generates and adds a random new Point.
      PVector Position=new PVector(random(E.SummonPos.x,E.SummonPos.x+E.SummonRect.x),random(E.SummonPos.y,E.SummonPos.y+E.SummonRect.y));
      PList.add(new Point(Position,new PVector(0,0),5,0.25+randomGaussian()*0.08,new float[]{},randomGaussian()*15,new float[]{}));
  }
  void AddNewPoi(){ ////Generates and adds a random new Point.
    if(random(1)>0.2){// 1 in 5 are eyes
      GenNewPoi();
    }else{
      GenNewEye();
    }
  }
  void AddNewConnectedPoi(){//Generated and ads a random new point with connections to others.
      if(random(1)>0.2){// 1 in 5 are eyes
        GenNewPoi();
      }else{
        GenNewEye();
      }
      int PoiA=PList.size()-1;
      int numMusc=abs(round(MuteAmount*randomGaussian()*2.2));
      if(numMusc<PList.size()-1){
       for(int i=0;i<numMusc;i++){
         int PoiB=randomInt(0,PList.size()-2);
         while((PoiA==PoiB)||(MuscInOrg(PoiA,PoiB))){
           PoiB=randomInt(0,PList.size()-2);
         }
         MList.add(new Muscle(PoiA,PoiB,new float[]{random(0,0.3),random(50,200),0.7},new float[]{random(0,0.3),random(50,200),0.7},new float[]{},randomGaussian()*15,new float[]{}));
         MList.get(MList.size()-1).O=this;
         MList.get(MList.size()-1).SetPois();
       }
     }
      
     int numNeu=abs(round(MuteAmount*randomGaussian()*1.2));
     if(numNeu<PList.size()-1+MList.size()){
       for(int i=0;i<numNeu;i++){
         int PoiB=randomInt(0,PList.size()+MList.size()-1);
         boolean Last=false;
         if(PoiB<=PList.size()-1){}else{
           Last=true;
           PoiB-=PList.size();
         }
         while(NeuInOrg(PoiA,Last,PoiB)
         ||((Last==false)&&((PoiA==PoiB)||(PList.get(PoiB) instanceof Eye)))
         ){
           PoiA=randomInt(0,PList.size()-1);
           PoiB=randomInt(0,PList.size()+MList.size()-1);
           Last=false;
           if(PoiB<=PList.size()-1){}else{
             Last=true;
             PoiB-=PList.size();
           }
         }
         NList.add(new Nerve(PoiA,Last,PoiB,randomInt(1,60)));
         NList.get(NList.size()-1).C=this;
         NList.get(NList.size()-1).SetPois();
       }
     }
  }
  void GenNewEye(){
     PVector Position=new PVector(random(E.SummonPos.x,E.SummonPos.x+E.SummonRect.x),random(E.SummonPos.y,E.SummonPos.y+E.SummonRect.y));
     ArrayList<PVector> RayDirs=new ArrayList<PVector>();
     int NumEyes= ceil(abs(randomGaussian()*0.7));
     for(int i=0;i<NumEyes;i++){
       float len= random(40,80);
       float ang=random(0,TWO_PI);
       PVector Dir= new PVector(len*cos(ang),len*sin(ang));
       RayDirs.add(Dir);
     }
     PList.add(new Eye(Position,new PVector(0,0),1,0,RayDirs,new float[]{},randomGaussian()*13));
  }
  
  void RemovePoi(int N){//Removes given point without ruining Nerves and Muscles
    for(int i=NList.size()-1;i>=0;i--){
      Nerve Neu=NList.get(i);
      if(Neu.IPoiNum==N){
        NList.remove(i);
      }
      if(Neu.Final==false){
        if(Neu.EPoiNum==N){
          NList.remove(i);
        }
      }
    }
    for(int i=MList.size()-1;i>=0;i--){
      Muscle Mus=MList.get(i);
      if((Mus.APoiNum==N)||(Mus.BPoiNum==N)){
        RemoveMusc(i);
        SetVars();
      }
    }
    
    PList.remove(N);
    
    for(int i=0;i<NList.size();i++){
      Nerve Neu=NList.get(i);
      Neu.IPoiNum=PList.indexOf(Neu.I);
      if(Neu.Final==false){
        Neu.EPoiNum=PList.indexOf(Neu.O);
      }
    }
    for(int i=0;i<MList.size();i++){
      Muscle Mus=MList.get(i);
      Mus.APoiNum=PList.indexOf(Mus.A);
      Mus.BPoiNum=PList.indexOf(Mus.B);
    }
  }
  void MutatePoi(int N){
    //float MuteAmount=0.3;
    Point Poi= PList.get(N);
    if(Poi.Type.equals("Input")){
      Poi.MutateSmart(MuteAmount*2.0);
    }else{
      Poi.MutateSmart(MuteAmount);
    }
    PVector Rand=new PVector(MuteAmount*randomGaussian()/2,MuteAmount*randomGaussian()/2);
    Poi.Pos=PVadd(Poi.Pos,Rand);
    if(Poi.Pos.x<E.SummonPos.x){
      Poi.Pos.x=E.SummonPos.x;
    }
    if(Poi.Pos.y<E.SummonPos.y){
      Poi.Pos.y=E.SummonPos.y;
    }
    if(Poi.Pos.x>E.SummonPos.x+E.SummonRect.x){
      Poi.Pos.x=E.SummonPos.x+E.SummonRect.x;
    }
    if(Poi.Pos.y>E.SummonPos.y+E.SummonRect.y){
      Poi.Pos.y=E.SummonPos.y+E.SummonRect.y;
    }
    Poi.Friction+=MuteAmount*randomGaussian()*0.015;
    if(Poi.Friction<0.2){
     Poi.Friction=0.2; 
    }
    if(Poi.Friction>0.7){
     Poi.Friction=0.7;
    }
    if (Poi.Type.equals("Input")){
      //PVector mult=new PVector(random(1.0-0.05*MuteAmount,1.0+0.05*MuteAmount),random(0.05*MuteAmount,-0.05*MuteAmount));
      Eye Inp= (Eye)Poi;
      float NumNewEyes=floor(abs(randomGaussian()*0.6*MuteAmount));     
      for(int i=0;i<NumNewEyes;i++){
       float len= random(40,80);
       float ang=random(0,TWO_PI);
       PVector Dir= new PVector(len*cos(ang),len*sin(ang));
       Inp.EyeRays.add(new Ray(Inp.Pos,Dir));
     }
        
      float NumDelEye=floor(abs(randomGaussian()*0.6*MuteAmount));
      for(int i=0;i<NumDelEye;i++){
         if(Inp.EyeRays.size()>1){
            int ind=randomInt(0,Inp.EyeRays.size()-1);
            Inp.EyeRays.remove(ind);
         }
      }
      
      for(int i=0;i<Inp.EyeRays.size();i++){
        Ray EyeRay=Inp.EyeRays.get(i);
        PVector mult=new PVector(1.0+randomGaussian()*0.06*MuteAmount,randomGaussian()*0.06*MuteAmount);
        PVector dir=EyeRay.Dir;
        EyeRay.Dir=PVMult(dir,mult);
        if (PVmag(dir)>100){
           EyeRay.Dir=PVsetmag( dir,100);
        }
        if( PVmag(dir)<50 ){
          EyeRay.Dir=PVsetmag( dir,50);
        }
      }
    }
  }
  
  boolean MuscInOrg(int Pa,int Pb){// Checks if a point number is already used in a mucscle. Stops double muscles.
    boolean end= false;
    for(int m= 0;m<MList.size();m++){
      Muscle M= MList.get(m);
      if(((M.APoiNum==Pa)&&(M.BPoiNum==Pb))||((M.BPoiNum==Pa)&&(M.APoiNum==Pb))){
        end=true;
      }
    }
    return end;
  }
  void GenNewMusc(){//Generates and adds a random new Muscle. For when the creature is initially made
     if(((PList.size()<2)||(MList.size()>=(PList.size()*(PList.size()-1))/2))==false){
       int PoiA=randomInt(0,PList.size()-1);
       int PoiB=randomInt(0,PList.size()-1);
       while((PoiA==PoiB)||(MuscInOrg(PoiA,PoiB))){
         PoiA=randomInt(0,PList.size()-1);
         PoiB=randomInt(0,PList.size()-1);
       }
       MList.add(new Muscle(PoiA,PoiB,new float[]{random(0,0.8),random(50,200),0.7},new float[]{random(0,0.8),random(50,200),0.7},new float[]{},randomGaussian()*15,new float[]{}));
       MList.get(MList.size()-1).O=this;
       MList.get(MList.size()-1).SetPois();
     }
  }
  void AddNewMusc(){//Generates and adds a random new Muscle. For when the creature being mutated-> less strong muscles, so less likely to break it
    if(((PList.size()<2)||(MList.size()>=(PList.size()*(PList.size()-1))/2))==false){
       int PoiA=randomInt(0,PList.size()-1);
       int PoiB=randomInt(0,PList.size()-1);
       while((PoiA==PoiB)||(MuscInOrg(PoiA,PoiB))){
         PoiA=randomInt(0,PList.size()-1);
         PoiB=randomInt(0,PList.size()-1);
       }
       MList.add(new Muscle(PoiA,PoiB,new float[]{random(0,0.3),random(50,200),0.7},new float[]{random(0,0.3),random(50,200),0.7},new float[]{},randomGaussian()*15,new float[]{}));
       MList.get(MList.size()-1).O=this;
       MList.get(MList.size()-1).SetPois();
    }
  }
  void RemoveMusc(int N){// Removes specified muscle, keeps Nerves from breaking
   for(int i=NList.size()-1;i>=0;i--){
      Nerve Neu=NList.get(i);
      if(Neu.Final){
        if(Neu.EPoiNum==N){
          NList.remove(i);
        }
      }
    }
    MList.remove(N);
    for(int i=0;i<NList.size();i++){
      Nerve Neu=NList.get(i);
      if(Neu.Final){
        Neu.EPoiNum=MList.indexOf(Neu.O);
      }
    }
  }
  void MutateMusc(int N){
    //float MuteAmount=0.3;
    Muscle Musc=MList.get(N);
    Musc.MutateSmart(MuteAmount);
    
    float[] StateMod=new float[3];
    //print("StateMod is "+StateMod[0]+"  "+StateMod[1]+"  "+StateMod[2]);
    StateMod[0]=randomGaussian()*.0005*MuteAmount;
    StateMod[1]=randomGaussian()*.001*MuteAmount;
    StateMod[2]=randomGaussian()*.0002*MuteAmount;
    Musc.StateA[0]+=StateMod[0];
    if(Musc.StateA[0]<0){
      Musc.StateA[0]=0;
    }if(Musc.StateA[0]>1){
      Musc.StateA[0]=1;
    }
    Musc.StateA[1]+=StateMod[1];
    if(Musc.StateA[1]<0){
      Musc.StateA[1]=0;
    }if(Musc.StateA[1]>200){
      Musc.StateA[1]=200;
    }
    Musc.StateA[2]+=StateMod[2];
    if(Musc.StateA[2]<0){
      Musc.StateA[2]=0;
    }if(Musc.StateA[2]>1){
      Musc.StateA[2]=1;
    }
    StateMod[0]=randomGaussian()*.0005*MuteAmount;
    StateMod[1]=randomGaussian()*001*MuteAmount;
    StateMod[2]=randomGaussian()*.0002*MuteAmount;
    //print("StateMod is "+StateMod[0]+"  "+StateMod[1]+"  "+StateMod[2]);
    Musc.StateB[0]+=StateMod[0];
    if(Musc.StateB[0]<0){
      Musc.StateB[0]=0;
    }if(Musc.StateB[0]>1){
      Musc.StateB[0]=1;
    }
    Musc.StateB[1]+=StateMod[1];
    if(Musc.StateB[1]<0){
      Musc.StateB[1]=0;
    }if(Musc.StateB[1]>200){
      Musc.StateB[1]=200;
    }
    Musc.StateB[2]+=StateMod[2];
    if(Musc.StateB[2]<0){
      Musc.StateB[2]=0;
    }if(Musc.StateB[2]>1){
      Musc.StateB[2]=1;
    }
  }
  boolean NeuInOrg(int Pa,boolean Last,int Pb){// Checks if a point number is already used in a Nerve.
    boolean end= false;
    for(int n= 0;n<NList.size();n++){
      Nerve N= NList.get(n);
      if(Last){
        if(N.Final){
          if(Pb==N.EPoiNum){// Only one Nerve can go to a muscle;
            end=true;
          }
        }
      }else{
        if(N.Final==false){
          if(((Pa==N.IPoiNum)&&(Pb==N.EPoiNum))||(Pb==N.IPoiNum)&&(Pa==N.EPoiNum)){
            end=true;
          }
        }
      }
    }
    return end;
  }
  boolean NewNeu(){// Checks if NewNeus are possible
    int EyePoiTaken=0;
    int PoiPoiTaken=0;
    int PoiMuscTaken=0;
    int NumLogics=0;
    int NumEyes=0;
    for(int p=0;p<PList.size();p++){
      Point P=PList.get(p);
      if(P instanceof Eye){
        NumEyes++;
      }else{
        NumLogics++;
      }
    }
    for(int n= 0;n<NList.size();n++){
      Nerve N= NList.get(n);
      if((N.Final==false)&&(N.I.Type=="Input")&&(N.O.Type!="Output")){
        EyePoiTaken++;
      }if((N.Final==false)&&(N.I.Type!="Input")&&(N.I.Type!="Output")){
        PoiPoiTaken++;
      }if(N.Final){
        PoiMuscTaken++;
      }
    }
    return ((EyePoiTaken<NumLogics*NumEyes)||(PoiPoiTaken<(NumLogics*(NumLogics-1))/2)||(PoiMuscTaken<MList.size()));
  }
  void GenNewNeu(){//Generates and adds a random new Nerve.
   if(NewNeu()){
     int PoiA=randomInt(0,PList.size()-1);
     int PoiB=randomInt(0,PList.size()+MList.size()-1);
     boolean Last=false;
     if(PoiB<=PList.size()-1){}else{
       Last=true;
       PoiB-=PList.size();
     }
     while(NeuInOrg(PoiA,Last,PoiB)
     ||((Last==false)&&((PoiA==PoiB)||(PList.get(PoiB) instanceof Eye)))
     ){
       PoiA=randomInt(0,PList.size()-1);
       PoiB=randomInt(0,PList.size()+MList.size()-1);
       Last=false;
       if(PoiB<=PList.size()-1){}else{
         Last=true;
         PoiB-=PList.size();
       }
     }
     NList.add(new Nerve(PoiA,Last,PoiB,randomInt(1,60)));
     NList.get(NList.size()-1).C=this;
     NList.get(NList.size()-1).SetPois();
   }
  }
  void AddNewNeu(){//Generates and adds a random new Nerve.
    GenNewNeu();
  }
  void RemoveNeu(int N){NList.remove(N);}
  void MutateNeu(int N){
    //float MuteAmount=0.4;
    Nerve Neu= NList.get(N);
    int Shift=round(randomGaussian()*0.002*MuteAmount);
    //print("Shift amount for delay is"+Shift);
    Neu.Delay+=Shift;
    if(Neu.Delay<1){
     Neu.Delay=1;
    }if(Neu.Delay>2*60){
      Neu.Delay=2*20;
    }
  }
  /* NickNacks- Other stuff
  */
  PVector CenterOfOrg(){
    PVector Center=new PVector(0,0);
    float TotalMass=0;
    for(int p=0;p<PList.size();p++){
      Point P=PList.get(p);
      if(!(P instanceof Eye)){
        Center= PVadd(Center,PVextend(P.Pos,P.Mass));
        TotalMass+=P.Mass;
      }
    }
    Center=PVextend(Center,float(1)/TotalMass);
    if(Float.isNaN(Center.x)||Float.isNaN(Center.y)){
      Center=new PVector(0,0);
    }
    return Center;
  }
  
}