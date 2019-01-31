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
  ArrayList<Neuron> NList=new ArrayList<Neuron>();
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
    return Number;
  }
  void SetVars(){ //Sets the muscles and neurons.
     SetMuscles();
     SetNeurons();
  }
  void SetMuscles(){// Lets muscle know what its Points and Organism is
    for(int m= 0;m<MList.size();m++){
      Muscle M= MList.get(m);
      M.O=this;
      M.SetPois();
    }
  }
  void SetNeurons(){// Gives Neuron necicary info
    for(int n= 0;n<NList.size();n++){
      Neuron N= NList.get(n);
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
  void PropogateNeurons(){// Sends the signals forward, and Calculates new signal (CalcSetPois)
    for(int p=0;p<PList.size();p++){// Sets all Inputs given back to 0
      Point P=PList.get(p);
      if(P instanceof Eye){// If Eye, find state;
        P.State=E.InGround(P);
      }
      if(P instanceof Logic){
        Logic LogicP=(Logic)P;
        LogicP.Inputs=LogicP.UncheckedIn;
        LogicP.InputsUsed=0;
      }
    }
   
    for(int n=0;n<NList.size();n++){//Shifts inputs, sets first to current state;
      Neuron N= NList.get(n);
      for(int s=1;s<N.StateList.length;s++){
          N.StateList[N.StateList.length-s]=N.StateList[N.StateList.length-s-1];    
      }
      N.StateList[0]=N.Ip.State;
      // Update states
      if(N.Final==true){   
        if((N.Em.State==N.StateList[N.Delay])==false){// Energy Calc???
          Energy++;// simple
        }
        N.Em.State=N.StateList[N.Delay];
      }else{
        if(N.Ep instanceof Logic){
          Logic ToNode=(Logic)N.Ep;
          if(ToNode.UncheckedIn.length<=ToNode.InputsUsed){
            ToNode.Inputs=expand(ToNode.Inputs,ToNode.Inputs.length+1); // Add to imputs.
          }
          ToNode.Inputs[ToNode.InputsUsed]=N.StateList[N.Delay];
          ToNode.InputsUsed++;
        }
      }
    }
    CalcSetPois();
  }
  void CalcSetPois(){// Sets the State of logics after reciving inputs
    for(int p=0;p<PList.size();p++){
      Point P=PList.get(p);
      if(P instanceof Logic){// if Point is of logic
        if(((Logic)P).CalcPossible()){// casts to logic , Checks and calcs logics.
          ((Logic)P).CalcLogic();
        }
      }
    }
  }
  void CalcNeurons(){// fully sets and propogates states
   // PointsFindState();
    PropogateNeurons();
  }
  void UpdatePois(){// Updates positions, forces of particeles and muscles
    for(int m=0;m<MList.size();m++){
      Muscle Musc =MList.get(m);
      Musc.CalcForce();
    }
    for(int p=0;p<PList.size();p++){
      Point Poi=PList.get(p);
      if((Poi instanceof Eye)==false){
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
  void DrawO(PVector Cam, PGraphics Canvas){// Draws all things in an organism
    for(int m=0;m<MList.size();m++){
      Muscle Musc =MList.get(m);
      fill(255);
      Musc.DrawM(Cam,Canvas);
      //fill(0);
      //text(m,(Musc.A.Pos.x+Musc.B.Pos.x)/2+5-Cam.x,(Musc.A.Pos.y+Musc.B.Pos.y)/2+5-Cam.y);
    }
    for(int n= 0;n<NList.size();n++){
      Neuron N= NList.get(n);
      N.DrawNeuron(Cam,Canvas);
    }
    for(int p=0;p<PList.size();p++){
      Point Poi=PList.get(p);
      fill(255);
      Poi.DrawP(Cam,Canvas);
      //fill(0);
      //text(p,Poi.Pos.x+10-Cam.x,Poi.Pos.y+10-Cam.y);
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
      Neuron Neu= NList.get(n);
      Org.NList.add(Neu.CloneNeuron());
      Org.NList.get(n).C= Org;
      Org.NList.get(n).SetPois();
    }
    return Org;
  }
  void MutateOrg(){
    MuteAmount+=randomGaussian()/10.0;
    for(int p=0;p<PList.size();p++){
      MutatePoi(p);
    }
    int NumPoiRemoved=abs(round(MuteAmount*randomGaussian()/2));
    for(int r=0;r<NumPoiRemoved;r++){
      if(PList.size()>0){
        RemovePoi(randomInt(0,PList.size()-1));
      }
    }
    int NumPoiAdded=abs(round(MuteAmount*randomGaussian()/2));
    for(int a=0;a<NumPoiAdded;a++){
      GenNewPoi();
    }
    for(int m=0;m<MList.size();m++){
      MutateMusc(m);
    }
    int NumMuscRemoved=abs(round(MuteAmount*randomGaussian()/2.3));
    for(int rm=0;rm<NumMuscRemoved;rm++){
      if(MList.size()>0){
        RemoveMusc(randomInt(0,MList.size()-1));
      }
    }
    int NumMuscAdded=abs(round(MuteAmount*randomGaussian()/2.1));
    for(int am=0;am<NumMuscAdded;am++){
      GenNewMusc();
    }
    for(int n=0;n<NList.size();n++){
      MutateNeu(n);
    }
    int NumNeuRemoved=abs(round(MuteAmount*randomGaussian()/2.3));
    for(int rn=0;rn<NumNeuRemoved;rn++){
      if(NList.size()>0){
        RemoveNeu(randomInt(0,NList.size()-1));
      }
    }
    int NumNeuAdded=abs(round(MuteAmount*randomGaussian()/2));
    for(int an=0;an<NumNeuAdded;an++){
      GenNewNeu();
    }
  }
  void GenNewPoi(){ ////Generates and adds a random new Point.
    PVector Position=new PVector(random(E.SummonPos.x,E.SummonPos.x+E.SummonRect.x),random(E.SummonPos.y,E.SummonPos.y+E.SummonRect.y));
      int LogicType=randomInt(0,2);
      int num= 0;
      if(LogicType==0) { num=2;
      }if(LogicType==1){ num=2;
      }if(LogicType==2){ num=1;}
      boolean[] SetInputs= new boolean[num];
      for(int i=0;i<SetInputs.length;i++){
        SetInputs[i]=randomInt(0,1)==0;
      }
      PList.add(new Logic(Position,new PVector(0,0),6,LogicType,SetInputs));
  }
  void GenNewEye(){
     PVector Position=new PVector(random(E.SummonPos.x,E.SummonPos.x+E.SummonRect.x),random(E.SummonPos.y,E.SummonPos.y+E.SummonRect.y));
     PList.add(new Eye(Position,new PVector(0,0),1));
  }
  
  void RemovePoi(int N){//Removes given point without ruining Neurons and Muscles
    for(int i=NList.size()-1;i>=0;i--){
      Neuron Neu=NList.get(i);
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
      Neuron Neu=NList.get(i);
      Neu.IPoiNum=PList.indexOf(Neu.Ip);
      if(Neu.Final==false){
        Neu.EPoiNum=PList.indexOf(Neu.Ep);
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
    if(Poi instanceof Logic){
      for(int i=0;i<((Logic)Poi).UncheckedIn.length;i++){
        if(random(0,1)<.1){
        ((Logic)Poi).UncheckedIn[i]=((Logic)Poi).UncheckedIn[i]==false;
        }
      }
      if(random(0,1)<.05){
        ((Logic)Poi).LogicType=randomInt(0,2);
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
  void GenNewMusc(){//Generates and adds a random new Muscle.
     if(((PList.size()<2)||(MList.size()>=(PList.size()*(PList.size()-1))/2))==false){
       int PoiA=randomInt(0,PList.size()-1);
       int PoiB=randomInt(0,PList.size()-1);
       while((PoiA==PoiB)||(MuscInOrg(PoiA,PoiB))){
         PoiA=randomInt(0,PList.size()-1);
         PoiB=randomInt(0,PList.size()-1);
       }
       MList.add(new Muscle(PoiA,PoiB,random(0,.5),random(50,200),0.7,random(0,.5),random(50,200),0.7));
       MList.get(MList.size()-1).O=this;
       MList.get(MList.size()-1).SetPois();
     }
  }
  void RemoveMusc(int N){// Removes specified muscle, keeps Neurons from breaking
   for(int i=NList.size()-1;i>=0;i--){
      Neuron Neu=NList.get(i);
      if(Neu.Final){
        if(Neu.EPoiNum==N){
          NList.remove(i);
        }
      }
    }
    MList.remove(N);
    for(int i=0;i<NList.size();i++){
      Neuron Neu=NList.get(i);
      if(Neu.Final){
        Neu.EPoiNum=MList.indexOf(Neu.Em);
      }
    }
  }
  void MutateMusc(int N){
    //float MuteAmount=0.3;
    Muscle Musc=MList.get(N);
    float[] StateMod=new float[3];
    //print("StateMod is "+StateMod[0]+"  "+StateMod[1]+"  "+StateMod[2]);
    StateMod[0]=randomGaussian()*.0005*MuteAmount;
    StateMod[1]=randomGaussian()*001*MuteAmount;
    //StateMod[2]=randomGaussian()*.005*MuteAmount;
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
    //Musc.StateA[2]+=StateMod[2];
    //if(Musc.StateA[2]<0){
    //  Musc.StateA[2]=0;
    //}if(Musc.StateA[2]>1){
    //  Musc.StateA[2]=1;
    //}
    StateMod[0]=randomGaussian()*.0005*MuteAmount;
    StateMod[1]=randomGaussian()*001*MuteAmount;
    //StateMod[2]=randomGaussian()*.005*MuteAmount;
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
    //Musc.StateB[2]+=StateMod[2];
    //if(Musc.StateB[2]<0){
    //  Musc.StateB[2]=0;
    //}if(Musc.StateB[2]>1){
    //  Musc.StateB[2]=1;
    //}
  }
  boolean NeuInOrg(int Pa,boolean Last,int Pb){// Checks if a point number is already used in a neuron.
    boolean end= false;
    for(int n= 0;n<NList.size();n++){
      Neuron N= NList.get(n);
      if(Last){
        if(N.Final){
          if(Pb==N.EPoiNum){// Only one Neuron can go to a muscle;
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
      if(P instanceof Logic){
        NumLogics++;
      }if(P instanceof Eye){
        NumEyes++;
      }
    }
    for(int n= 0;n<NList.size();n++){
      Neuron N= NList.get(n);
      if((N.Final==false)&&(N.Ip instanceof Eye)&&(N.Ep instanceof Logic)){
        EyePoiTaken++;
      }if((N.Final==false)&&(N.Ip instanceof Logic)&&(N.Ep instanceof Logic)){
        PoiPoiTaken++;
      }if(N.Final){
        PoiMuscTaken++;
      }
    }
    return ((EyePoiTaken<NumLogics*NumEyes)||(PoiPoiTaken<(NumLogics*(NumLogics-1))/2)||(PoiMuscTaken<MList.size()));
  }
  void GenNewNeu(){//Generates and adds a random new neuron.
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
     NList.add(new Neuron(PoiA,Last,PoiB,randomInt(1,60)));
     NList.get(NList.size()-1).C=this;
     NList.get(NList.size()-1).SetPois();
   }
  }
  void RemoveNeu(int N){NList.remove(N);}
  void MutateNeu(int N){
    //float MuteAmount=0.4;
    Neuron Neu= NList.get(N);
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
      Center= PVadd(Center,PVextend(P.Pos,P.Mass));
      TotalMass+=P.Mass;
    }
    Center=PVextend(Center,float(1)/TotalMass);
    return Center;
  }
  
}