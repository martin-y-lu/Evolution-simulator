class Enviroment{
  ArrayList<Barrier> BList= new ArrayList<Barrier>();
  ArrayList<Organism> OList= new ArrayList<Organism>();
  ArrayList<Tester> TestList= new ArrayList<Tester>();
  PVector SummonPos;
  PVector SummonRect;
  ArrayList<String[]>HistoGramInfo=new ArrayList<String[]>();
  String[] SpeciesFitnessInfo= new String[5000];
  ArrayList<String> SpeciesAbundanceInfo=new ArrayList<String>();
  
  void SetVars(){// Sets all the E's in all orrganisms.
    for(int O=0;O<OList.size();O++){
      Organism Org=OList.get(O);
      Org.E=this;
    }
  }
  Enviroment CloneEnv(){
    Enviroment NewEnv=new Enviroment();
    for(int b=0;b<BList.size();b++){
      NewEnv.BList.add(BList.get(b).CloneBarrier());
    }
    for(int o=0;o<OList.size();o++){
      NewEnv.OList.add(OList.get(o).CloneOrganism());
    }
    for(int t=0;t<TestList.size();t++){
      NewEnv.TestList.add(TestList.get(t).CloneTester());
    }
    NewEnv.SetSummonArea(SummonPos,SummonRect);
    NewEnv.HistoGramInfo=HistoGramInfo;
    NewEnv.SpeciesFitnessInfo=SpeciesFitnessInfo;
    NewEnv.SpeciesAbundanceInfo=SpeciesAbundanceInfo;
    return NewEnv;
  }
  Enviroment StoreEnv(){//Enviroment for prevEnviroment
    Enviroment NewEnv=new Enviroment();
    for(int b=0;b<BList.size();b++){
      NewEnv.BList.add(BList.get(b).CloneBarrier());
    }
    //0,10,20,30,40,50,60,70,80,90,100 percentile creatures kept
    for(int i=0;i<=10;i++){
      int index=floor(float((OList.size()-1)*i)/10.0);
      NewEnv.OList.add(OList.get(index).CloneOrganism());
      NewEnv.TestList.add(TestList.get(index).CloneTester());
    }
    NewEnv.SetSummonArea(SummonPos,SummonRect);
    NewEnv.HistoGramInfo=HistoGramInfo;
    NewEnv.SpeciesFitnessInfo=SpeciesFitnessInfo;
    NewEnv.SpeciesAbundanceInfo=SpeciesAbundanceInfo;
    return NewEnv;
  }
  void SetInfo(){
    println(" Setting Info:");
    float[] Fitnesses= new float[Env.TestList.size()];
    for(int i=0;i<Env.TestList.size();i++){
      float fitness=0.0;
      if(Env.TestList.get(i).Finalized){
        fitness=Env.TestList.get(i).Fitness;
        if(Float.isNaN(fitness)){
          fitness=0;
        }
        if(i%1000==0){
          println("  Example fitness index:"+i+"  fitness:"+Env.TestList.get(i).Fitness);
        }
      }
      Fitnesses[i]=fitness;
    }
    println("  Fitness length:"+Fitnesses.length);

    float max=max(Fitnesses);
    float min=min(Fitnesses);
    float divSize=2;
    //int upperIndex= ceil(max/divSize);
    //int lowerIndex= floor(min/divSize);
    SpeciesFitnessInfo=SpeciesFitness();
    SpeciesAbundanceInfo=SpeciesAbundance();
    print("  SpeciesAbundanceInfo set "+SpeciesAbundanceInfo.size());
    HistoGramInfo=HistoGramSpeciesAbundance(min,max,divSize);
  }
  String[] SpeciesFitness(){ //An array strings, every creature species with its fitness
    String[] SpeFit=new String[TestList.size()];
    for(int t=0;t<TestList.size();t++){
      SpeFit[t]=SpeciesName(TestList.get(t).O.SpeciesNumber())+" "+TestList.get(t).Fitness;
    }
    return SpeFit;
  }
  ArrayList<String> SpeciesAbundance(){//Array of strings with species name and number of occurences concaatenated
    ArrayList<String> SpeciesName=new ArrayList<String>();
    ArrayList<Integer> SpeciesFreq=new ArrayList<Integer>();
    for(int t=0;t<TestList.size();t++){
      String Name=SpeciesName(TestList.get(t).O.SpeciesNumber());
      if(SpeciesName.contains(Name)){
        int ind=SpeciesName.indexOf(SpeciesName(TestList.get(t).O.SpeciesNumber()));
        SpeciesFreq.set(ind,SpeciesFreq.get(ind)+1);
      }else{
        SpeciesName.add(Name);
        SpeciesFreq.add(1);
      }
    }
    String[] SpeAb=new String[SpeciesName.size()];
    for(int s=0;s<SpeAb.length;s++){
      SpeAb[s]=SpeciesName.get(s)+" "+SpeciesFreq.get(s);
    }
    SpeAb=sort(SpeAb);
    
    ArrayList<String> SpeciesAbundance=new ArrayList(Arrays.asList(SpeAb));
    print("Calculating Species ABundance, "+SpeciesAbundance.size()+" different Species");
    return SpeciesAbundance;
  }
  ArrayList<String[]> HistoGramSpeciesAbundance(float min, float max,float Step){
    println("Calculating Histogram Species abundace:");
    println("  Max:"+max+" Min"+min);
    int upperIndex= ceil(max/Step);
    int lowerIndex= floor(min/Step);
    int numCol=upperIndex-lowerIndex+1;
    println("  Upper Index:"+upperIndex+" Lower Index:"+lowerIndex+" NumColumns:"+numCol);
    ArrayList<ArrayList<String>> SpeciesPercentile=new ArrayList<ArrayList<String>>(numCol);
    while(SpeciesPercentile.size()<numCol){SpeciesPercentile.add(new ArrayList<String>(0));};
    ArrayList<ArrayList<Integer>> SpeciesFrequency=new ArrayList<ArrayList<Integer>>(numCol);
    while(SpeciesFrequency.size()<numCol){SpeciesFrequency.add(new ArrayList<Integer>(0));};
    
    //int[] Percentile= new int[numCol];
    for(int i=0;i<TestList.size();i++){
      int index= floor(TestList.get(i).Fitness/Step)-lowerIndex;
      //Percentile[index]++;
      ArrayList<String> SpName=SpeciesPercentile.get(index);
      ArrayList<Integer>SpFreq=SpeciesFrequency.get(index);
      Organism TO=TestList.get(i).O;
      if(SpName.contains(SpeciesName(TO.SpeciesNumber()))){
        int SpeciesIndex=SpName.indexOf(SpeciesName(TO.SpeciesNumber()));
        SpFreq.set(SpeciesIndex,SpFreq.get(SpeciesIndex)+1);
      }else{
        SpName.add(SpeciesName(TO.SpeciesNumber()));
        SpFreq.add(1);
      }
    }
    ArrayList<String[]> SpeciesNameFreq= new ArrayList<String[]>(numCol);
    while(SpeciesNameFreq.size()<numCol){SpeciesNameFreq.add(new String[0]);};
    for(int i=0;i<numCol;i++){
      String[] NameFreq=new String[SpeciesPercentile.get(i).size()];
      for(int s=0;s<NameFreq.length;s++){
        NameFreq[s]=SpeciesPercentile.get(i).get(s)+" "+SpeciesFrequency.get(i).get(s);
      }
      NameFreq=sort(NameFreq);
      SpeciesNameFreq.set(i,NameFreq);
    }
    return SpeciesNameFreq;
  }
  int[] CalcPercentile(float min, float max,float Step){
    int upperIndex= ceil(max/Step);
    int lowerIndex= floor(min/Step);
    int numCol=upperIndex-lowerIndex+1;
    int[] Percentile= new int[numCol];
    for(int i=0;i<TestList.size();i++){
      int index= floor(TestList.get(i).Fitness/Step)-lowerIndex;
      Percentile[index]++;
    }
    return Percentile;
  }
  int[] Percentile(){
    int[] Percentile= new int[HistoGramInfo.size()];
    for(int i=0;i<Percentile.length;i++){
      Percentile[i]=0;
      for(int p=0;p<HistoGramInfo.get(i).length;p++){
        String[] Split=split(HistoGramInfo.get(i)[p]," ");
        Percentile[i]+=Integer.parseInt(Split[1]);
      }
    }
    return Percentile;
  }
  void ShiftToTest(int N){
    TestList.add(new Tester(OList.get(N).CloneOrganism(),this,15*60));
  }
  void ReshiftToTest(){
    TestList.clear();
    for(int i=0;i<OList.size();i++){
     ShiftToTest(i); 
    }
  }
  void SetSummonArea(PVector Pos,PVector Rect){
    SummonPos=Pos; SummonRect=Rect;
  }
  boolean AllFinalized(){
    boolean finals=false;
    for(int t=0;t<TestList.size();t++){
      finals=finals&&TestList.get(t).Finalized;
    }
    return finals;
  }
  void TestAll(){
    for(int t=0;t<TestList.size();t++){
      TestList.get(t).QuickRunTest();
    }
  }
  void QuickGen(){
    Reproduce();
    TestAll();
    SortTests();
  }
  void MutateAll(){
    for(int O=0;O<OList.size();O++){
      Organism Org=OList.get(O);
      Org.MutateOrg();
    }
  }
  void Trim(float frac){
    //int PrevSize=OList.size();
    //for(int i=0; i<OList.size();i++){//Kill the crowd
    //  if(random(1)<(float)i/(float)OList.size()){
    //    OList.remove(i);
    //    i--;
    //  }
    //}
    int PrevSize=OList.size();
    int cutPoint=round(PrevSize*frac);
    Boolean[]Live=new Boolean[OList.size()];
    float variance=100*5000.0;
    for(int i=0;i<Live.length;i++){
      Live[i]= i<cutPoint;
      float gauss=exp(-pow((float(i)-cutPoint),2.0)/(2.0*variance))/2.0;
      if(random(1)<gauss){
        Live[i]=!Live[i];
      }
    }
    for(int n=Live.length-1;n>=0;n--){
      if(!Live[n]){
         OList.remove(n);
      }
    }
    //while(OList.size()>i){
    //    OList.remove(abs(i-abs(round(randomGaussian()*0.02))));
    //}
  }
  void Reproduce(){
    int NumOrganisms=5000;
    //float Trim=0.4;  Trim+ Power function distribution
    //float Power=-0.2;
    //float SurvFract=0.90;
    //float Multiplier=SurvFract*(Power+1)/pow(1-Trim,Power+1);
    //Trim(1-Trim);
    //int PrevSize=OList.size()-1;
    //for(int i=0; i<PrevSize;i++){
    //  float rank=lerp(0,1-Trim,1-(float)i/PrevSize);
    //  int numOffspring=round(randomGaussian()*0.5+Multiplier*pow(rank,Power));//abs(round(randomGaussian()*(pow(rank,2)*2.7)))+1;
    //  for(int j=0; j<numOffspring;j++){
    //    Organism MutatedClone=OList.get(i).CloneOrganism();
    //    MutatedClone.E=this;
    //    MutatedClone.MutateOrg();
    //    OList.add(MutatedClone);
    //  }
    //}
    //int targSize=OList.size()-PrevSize;
    //while(OList.size()>targSize){
    //  OList.remove(OList.size()-1);
    //}
    
    // Target population distributon- Discrete
    float[] Fitnesses= new float[TestList.size()];
    for(int i=0;i<TestList.size();i++){
      float fitness=0.0;
      if(TestList.get(i).Finalized){
        fitness=TestList.get(i).Fitness;
      }
      Fitnesses[i]=fitness;
    }
    float max=max(Fitnesses);
    float min=min(Fitnesses);
    float divSize=(max-min)/10.0;
    int upperIndex= ceil(max/divSize);
    int lowerIndex= floor(min/divSize);
    int numCol=upperIndex-lowerIndex+1;
    println("num percentiles:"+numCol);
    ArrayList<ArrayList<Tester>> FitTestList=new ArrayList<ArrayList<Tester>>(numCol);
    while(FitTestList.size()<numCol){FitTestList.add(new ArrayList<Tester>(0));};
    for(int i=0;i<TestList.size();i++){
      int index= floor(TestList.get(i).Fitness/divSize)-lowerIndex;
      FitTestList.get(index).add(TestList.get(i));
    }
    float[] TargetPopList={0,1,4,9,16,25,36,49,64,81,100,121,144};// The fractional representation of each percentile. Doesn't have to be normalised
    float Total=0;// Make sure the total is 1. 
    for(int n=0;n<TargetPopList.length;n++){ Total+=TargetPopList[n]; }
    for(int n=0;n<TargetPopList.length;n++){ TargetPopList[n]=TargetPopList[n]/Total;}
    OList.clear();
    for(int f=0;f<numCol;f++){//Reproduce using the target representation.
      ArrayList<Tester> Testers=FitTestList.get(f) ;
      float AvNumChildren=1.4*5000.0*TargetPopList[f]/float(Testers.size());
      println("AvNumChildren "+AvNumChildren);
      for(int c=0;c<Testers.size();c++){
        int NumChilderen=round(randomGaussian()/2.0+AvNumChildren);
        for(int p=0;p<NumChilderen;p++){
          Organism MutatedClone=Testers.get(c).OOriginal.CloneOrganism();
          MutatedClone.E=this;
          MutatedClone.MutateOrg();
          OList.add(MutatedClone);
        }
      }
    }
    println("Population after reproduce "+ OList.size());
    //Insure size
    while(OList.size()<NumOrganisms){
        GenNewOrg();
    }  
  
    while(OList.size()>NumOrganisms){
        OList.remove(NumOrganisms-1);
    }
    TestList.clear();
    for(int i=0; i<OList.size();i++){
      ShiftToTest(i);
    }

    //for(int L=0;L<=TestList.size()-2;L++){
    //  for(int M=0;M<=TestList.size()-L-2;M++){
    //    Tester One=TestList.get(M);
    //    Tester Two=TestList.get(M+1);
    //    if(One.Fitness>Two.Fitness){
    //    }
    //  }
    //}
    
  }
  void GenNewOrg(){//Generates new Random Organism
    Organism O= new Organism();
    O.E=this;
    int NumPois=randomInt(3,5);
    for(int I=0;I<NumPois;I++){
      O.GenNewPoi();
    }
    int NumEyes=randomInt(1,3);
    for(int I=0;I<NumEyes;I++){
      O.GenNewEye();
    }
    int NumMusc=randomInt(3,(NumPois+NumEyes)*((NumPois+NumEyes)-1)/2);
    for(int M=0;M<NumMusc;M++){
      O.GenNewMusc();
    }
    int NumNeu=randomInt(2,5);
    for(int N=0;N<NumNeu;N++){
      O.GenNewNeu();
    }
    OList.add(O);
  }
  void SortTests(){
    //TestList.clear();
    //TestList=QuickSortTests(TestList);
    Collections.sort(TestList);
    OList.clear();
    for(int i=0; i<TestList.size();i++){
      OList.add(TestList.get(i).OOriginal);
    }
  }
  //ArrayList<Tester> QuickSortTests(ArrayList<Tester> Tests){ Now using Comparitor interface
  //  //for(int n=0;n<TestList.size();n++){ BubbleSort Sucks.
  //  //  for(int i=TestList.size()-1;i>n;i--){
  //  //    Tester First =TestList.get(i);
  //  //    Tester Next = TestList.get(i-1);
  //  //    boolean swap=false;
  //  //    if(First.Finalized&&!Next.Finalized){
  //  //      swap=true;
  //  //    }else if(Next.Finalized&&First.Finalized){
  //  //      if(First.Fitness>Next.Fitness){
  //  //        swap=true;
  //  //      }
  //  //    }
  //  //    if(swap){
  //  //      //print("swap");
  //  //      Tester HoldFirst=First.CloneTester();
  //  //      TestList.set(i,Next.CloneTester());
  //  //      TestList.set(i-1,HoldFirst);
  //  //      Organism HoldO=OList.get(i).CloneOrganism();
  //  //      OList.set(i,OList.get(i-1).CloneOrganism());
  //  //      OList.set(i-1,HoldO);
  //  //    }
  //  //  }
  //  //}
    
  //  if (Tests.size() <= 1) {
  //    return Tests;
  //  }else{
  //    ArrayList<Tester> Less=new ArrayList<Tester>();
  //    ArrayList<Tester> Equal=new ArrayList<Tester>();
  //    ArrayList<Tester> More=new ArrayList<Tester>();
  //    Tester T0=Tests.get(0);
  //    for(int i=0;i<Tests.size();i++){
  //      Tester T=Tests.get(i);
  //      if((!T.Finalized&&!T0.Finalized)||(T.Fitness==T0.Fitness)){
  //        Equal.add(T);
  //      }else if( !T0.Finalized||(T.Fitness>T0.Fitness)){
  //        More.add(T);
  //      }else{
  //        Less.add(T);
  //      }
  //    }
  //    ArrayList<Tester> Total=new ArrayList<Tester>();
  //    Total.addAll(QuickSortTests(More));
  //    Total.addAll(Equal);
  //    Total.addAll(QuickSortTests(Less));
  //    return Total;
  //  }
  //}
  
  Boolean InGround(Point P){// Checks if any Point P is within the ground in the Enviroment.
    boolean Under=false;
    for(int f=0;f<BList.size();f++){
      Barrier F=BList.get(f);
      Under=Under||F.WithinBarr(P);
    }
    return Under;
  }
  boolean MoreCalc(Point P){// Sees if any particles are colliding
    Boolean more=false;
    for(int o=0;o<BList.size();o++){
      Barrier B=BList.get(o);
      more=more||B.Collides(P);
    }
    return more;
  }
  int NumColliding(Point P){//number of particles colliding
    int coll=0;
    for(int o=0;o<BList.size();o++){
      Barrier B=BList.get(o);
      if(B.Collides(P)){
        coll++;
      }
    }
    return coll;
  }
  void DrawEnv(int N,PVector Cam,PGraphics Canvas){// Draws ground and organisms.
    for(int f=0;f<BList.size();f++){
      BList.get(f).DrawBarr(Cam,Canvas);
    }
    TestList.get(N).O.DrawO(Cam,Canvas);
  }
  void DrawGround(PVector Cam,PGraphics Canvas){
    for(int f=0;f<BList.size();f++){
      BList.get(f).DrawBarr(Cam,Canvas);
    }
  }
  void DrawOrg(int N,PVector Cam,PGraphics Canvas){
    TestList.get(N).O.DrawO(Cam,Canvas);
  }
}

class Tester implements Comparable<Tester>{
  Organism OOriginal;
  Organism O;
  Enviroment E;
  float RunTime=60*50;
  boolean Finalized=false;
  float Fitness=0;
  Tester(Organism dO,Enviroment dE,float dRunTime){
    OOriginal=dO;
    O=OOriginal.CloneOrganism();
    E=dE;
    OOriginal.E=E;
    O.E=E;
    RunTime=dRunTime;
    SetTester();
  }
  Tester CloneTester(){
    Tester Clone=new Tester(O.CloneOrganism(),E,RunTime);
    Clone.Finalized=Finalized;
    Clone.Fitness=Fitness;
    return Clone;
  }
  void Reset(){
    O= OOriginal.CloneOrganism();
    O.E=E;
    SetTester();
    Finalized=false;
  }
  float time;
  void SetTester(){
    time=0;
  }
  void UpdateOrg(){// Updates positions, forces on Organism #N.
    O.CalcNeurons();
    O.UpdatePois();
  }
  boolean EndTest(){
    return time>RunTime;
  }
  float EvaluateFitness(){
    return O.CenterOfOrg().x;
  }
  void RunTest(){
    if(Finalized==false){
      UpdateTest();
      UpdateOrg();
      if(EndTest()){
        Finalized=true;
        Fitness=EvaluateFitness();
      }
    }
  }
  void UpdateTest(){
    time++;
  }
  void QuickRunTest(){
    while(Finalized==false){
      RunTest();
    }
  }
  int compareTo(Tester T) {
    return Float.compare(T.Fitness,Fitness);
    //if(T.Fitness<Fitness){
    //  return -1;
    //}else if(T.Fitness>Fitness){
    //  return 1;
    //}else{
    //  return 0;
    //}
  }
}