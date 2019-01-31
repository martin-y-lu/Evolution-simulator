import java.util.*;
class Button{
  PVector Pos;
  PVector Size;
  String Text;
  Button(PVector DPos,PVector DSize,String DText){
    Pos=DPos; Size=DSize; Text=DText;
  }
  Boolean IsPressed(){
    return mousePressed&&(PrevMouse==false)&&FLtween(Pos.x,Pos.x+Size.x,mouseX)&&FLtween(Pos.y,Pos.y+Size.y,mouseY);
  }
  void Display(color C){
    stroke(0);
    fill(C);
    rect(Pos.x,Pos.y,Size.x,Size.y);
    fill(0);
    text(Text,Pos.x+5,Pos.y+15);
  }
}
class Slider{
  PVector ScreenPos;
  String Text;
  float Pos=0;
  float Min;
  float Max;
  boolean Slide=false;
  Slider(PVector dScreenPos,String dText,float dMin,float dMax){
   ScreenPos=dScreenPos; Text= dText; Min=dMin; Max=dMax;
  }
  boolean Sliding(){
    return mousePressed&&(mouseX>Pos+ScreenPos.x)&&(mouseX<Pos+ScreenPos.x+90)
    &&(mouseY>ScreenPos.y-10)&&(mouseY<ScreenPos.y+20+10)&&(Pos>=Min)&&(Pos<=Max);
  }
  void ChangeText(String NewT){
    Text=NewT;
  }
  void CalcSlide(){
    if(Sliding()||Slide){
     Slide=true;
      Pos=mouseX-ScreenPos.x-45;
    }
    if(!mousePressed){
     Slide=false; 
    }
    if(Pos>Max){
       Pos=Max;
    }if(Pos<Min){
       Pos=Min;
    }
  }
  void Display(){
    fill(255);
    rect(ScreenPos.x+Pos,ScreenPos.y,80,20);
    fill(0);
    text(Text,ScreenPos.x+Pos+10,ScreenPos.y+15);
  }
}

Organism Test= new Organism();
Enviroment Env= new Enviroment();
int EnvNumber=0;
ArrayList<Enviroment> PastEnvs=new ArrayList<Enviroment>();
void ResetEnv(){
  if(EnvNumber!=PastEnvs.size()-1){
    EnvNumber=PastEnvs.size()-1;
    //Env=PastEnvs.get(EnvNumber);
  }
}
void SetEnv(int Number){
  EnvNumber=Number;
  Env=PastEnvs.get(EnvNumber).CloneEnv();
  //Env.ReshiftToTest();
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
PVector Cam= new PVector(0,0);
float Energy=0;
boolean PrevMouse=false;
int LastTime = 0;
PGraphics MainScreen;
PGraphics HistoGram;
PGraphics SpeciesFreq;
PGraphics BestOrg;
PGraphics MedianOrg;
PGraphics WorstOrg;
void setup(){
  randomSeed(6);
  //Seeds with interesting stuffs
  //5- Organism that uses a spining eye to time all other movements.
  //6- Two points in front that pull.
  //7- Galloping with two feet behind
  //8- Strange scooty creatures
  //12- Leaping creatures timed with two eyes below
  //size(1280, 720);
  fullScreen();
  //stroke(0); 
  //strokeWeight(3);
  frameRate(60);
  HistoGram=createGraphics(400,200);
  SpeciesFreq=createGraphics(510,260);//createGraphics(510,60);
  WorstOrg=createGraphics(200,200);
  MedianOrg=createGraphics(200,200);
  BestOrg=createGraphics(200,200);
  MainScreen=createGraphics(width,height);
    
  Env.SetSummonArea(new PVector(0,100),new PVector(200,200));
  Env.OList.add(new Organism());
  Env.OList.get(0).PList.add(new Logic(new PVector(100,130),new PVector(0,0),1,0,new boolean[]{true,true}));
  Env.OList.get(0).PList.add(new Logic(new PVector(200,130),new PVector(0,0),5,2,new boolean[]{}));
  Env.OList.get(0).PList.add(new Point(new PVector(150,80),new PVector(0,0),5));
  Env.OList.get(0).PList.add(new Eye(new PVector(150,130),new PVector(0,0),5));
  //Env.OList.get(0).PList.add(new Eye(new PVector(150,130),new PVector(0,0),8));
 // Env.OList.get(0).PList.add(new Logic(new PVector(30,130),new PVector(0,0),1,0,new boolean[]{true}));
  Env.OList.get(0).MList.add(new Muscle(0,1,.4,110,.2,1,160,.2));
  Env.OList.get(0).MList.add(new Muscle(1,2,.4,110,.2,1,160,.2));
  Env.OList.get(0).MList.add(new Muscle(2,0,.4,110,.2,1,160,.2));
  Env.OList.get(0).MList.add(new Muscle(2,3,1,110,.2,1,160,.2));
  Env.OList.get(0).NList.add(new Neuron(3,false,0,15));
  //Env.OList.get(0).NList.add(new Neuron(4,false,0,30));
  Env.OList.get(0).NList.add(new Neuron(0,false,1,15));
  Env.OList.get(0).NList.add(new Neuron(1,true,3,30));
  Env.OList.get(0).SetVars();
  
  Env.OList.add(new Organism());
  Env.OList.get(1).PList.add(new Logic(new PVector(150,81),new PVector(0,0),1,1,new boolean[]{}));
  Env.OList.get(1).PList.add(new Logic(new PVector(151,80),new PVector(0,0),1,1,new boolean[]{}));
  Env.OList.get(1).PList.add(new Logic(new PVector(150,82),new PVector(0,0),1,1,new boolean[]{}));
  Env.OList.get(1).MList.add(new Muscle(0,1,.4,110,.2,1,160,.2));
  Env.OList.get(1).MList.add(new Muscle(1,2,.4,110,.2,1,160,.2));
  Env.OList.get(1).MList.add(new Muscle(2,0,.4,110,.2,1,160,.2));
  Env.OList.get(1).NList.add(new Neuron(0,true,1,15)); 
  Env.OList.get(1).NList.add(new Neuron(1,true,2,15));
  Env.OList.get(1).NList.add(new Neuron(2,true,0,15));
  Env.OList.get(1).SetVars();
  
  Env.OList.add(new Organism());
  Env.OList.get(2).PList.add(new Point(new PVector(150,0-500),new PVector(0,0),1));
  Env.OList.get(2).PList.add(new Point(new PVector(0,0-500),new PVector(0,0),1));
  Env.OList.get(2).PList.add(new Point(new PVector(0,0-500),new PVector(0,0),1));
  Env.OList.get(2).PList.add(new Point(new PVector(0,150-500),new PVector(0,0),1));
  Env.OList.get(2).MList.add(new Muscle(0,1,.4,110,.2,1,160,.2));
  Env.OList.get(2).MList.add(new Muscle(2,3,.4,110,.2,1,160,.2));
  Env.OList.get(2).SetVars();
  //Env.GenNewOrg();
 
  Env.BList.add(new Barrier(new PVector(-2000,300),new PVector(10000,0),.2,.1));
  Env.GenNewOrg();
  
  Env.SetVars();
  Env.ShiftToTest(0);
  Env.ShiftToTest(1);
  Env.ShiftToTest(2);
  Env.ShiftToTest(3);
  for(int i=0;i<500;i++){
   //print(abs(round(randomGaussian())));
   //print(randomGaussian());
  }
  //FillHisto(HistoGram);
  //Env.QuickGen();
  //Env.SetInfo();
  //FillHisto(HistoGram);
  //AddEnv(Env);
}
int CurrentTestDisplay=0;
int CurrentEnv=0;
int PlayBackSpeed=1;
boolean ALAP=false;
Slider OrgSlide=new Slider(new PVector(100,100),"Org-",0,10);
Slider GenSlide=new Slider(new PVector(100,230),"Gen-",0,10);
void draw(){
  background(160,190,255); 
  if(mouseY<80){
    Cam.y-=12;
  }if(mouseY>height-80){
    Cam.y+=12;
  }if(mouseX<80){
    Cam.x-=12;
  }if(mouseX>width-80){
    Cam.x+=12;
  }
  //_____________________________________________________________________________________________
  // Main screen draw, enviroment draw & Update
  MainScreen.beginDraw();
  MainScreen.background(160,190,255);

  //Env.UpdateOrg(0);
  // Env.TestList.get(0).PList.get(4).Pos=new PVector(mouseX+Cam.x,mouseY+Cam.y);
  if(CurrentTestDisplay>=Env.TestList.size()){
    CurrentTestDisplay=Env.TestList.size()-1;
  }
  for(int i=0;i<PlayBackSpeed;i++){
     Env.TestList.get(CurrentTestDisplay).RunTest();
  }
  MainScreen.text("Time-"+Env.TestList.get(CurrentTestDisplay).time,20,50);
  MainScreen.text("delta Time-"+(millis()-LastTime),width-100,20);
  if(Env.TestList.get(CurrentTestDisplay).Finalized){
    MainScreen.text("Fitness-"+Env.TestList.get(CurrentTestDisplay).Fitness,20,60);
  }
  PVector OrgCenter=Env.TestList.get(CurrentTestDisplay).O.CenterOfOrg();
  MainScreen.fill(255);
  MainScreen.stroke(0);
  MainScreen.triangle(OrgCenter.x-Cam.x,100,OrgCenter.x-20-Cam.x,50,OrgCenter.x+20-Cam.x,50);
  MainScreen.fill(140,170,255);
  MainScreen.rect(Env.SummonPos.x-Cam.x,Env.SummonPos.y-Cam.y,Env.SummonRect.x,Env.SummonRect.y);
  Env.DrawGround(Cam,MainScreen);
  Env.DrawOrg(CurrentTestDisplay,Cam,MainScreen);
  MainScreen.text(mouseX+" "+mouseY,10,10);
  MainScreen.text("Camera-"+ Cam.x+" "+Cam.y,10,20);
  MainScreen.text("Energy-"+Energy,10,30);
  MainScreen.endDraw();
  //tint(255,255);
  image(MainScreen,0,0);
  
  
  //_____________________________________________________________________________________________
  //Draw HistoGram and Species Percent graphs
  Button DrawHisto= new Button(new PVector(280,10),new PVector(60,20),"DrawHistoGram");
  DrawHisto.Display(255);
  if(DrawHisto.IsPressed()){  
    //Env.SetInfo();
    FillHisto(HistoGram);
    FillSpeciesFreq(SpeciesFreq);
  }
  image(HistoGram, width-(1280-820), 30); 
  
  //SpeciesFreq.beginDraw();
  //SpeciesFreq.background(255);
  //FillSpeciesFreq(SpeciesFreq);
  //SpeciesFreq.endDraw();
  image(SpeciesFreq,100,260);
  //_____________________________________________________________________________________________
  //Best, Worst, and median creatures
  WorstOrg.beginDraw();
  WorstOrg.background(200,220,255);
  
  WorstOrg.stroke(0);
  WorstOrg.strokeWeight(3);
  WorstOrg.noFill();
  WorstOrg.rect(0,0,200,200);
  int worst=Env.OList.size()-1;
  PVector CenterOrg=Env.OList.get(worst).CenterOfOrg();
  Env.OList.get(worst).DrawO(new PVector(CenterOrg.x-100,CenterOrg.y-100),WorstOrg);
  WorstOrg.endDraw();
  image(WorstOrg, width-(1280-820), 250,100,100); 
  
  MedianOrg.beginDraw();
  MedianOrg.background(200,220,255);
  MedianOrg.stroke(0);
  MedianOrg.strokeWeight(3);
  MedianOrg.noFill();
  MedianOrg.rect(0,0,200,200);
  int median=floor((float)Env.OList.size()/2.0);
  CenterOrg=Env.OList.get(median).CenterOfOrg();
  Env.OList.get(median).DrawO(new PVector(CenterOrg.x-100,CenterOrg.y-100),MedianOrg);
  MedianOrg.endDraw();
  image(MedianOrg, width-(1280-970), 250,100,100); 
  
  
  BestOrg.beginDraw();
  BestOrg.background(200,220,255);
  
  BestOrg.stroke(0);
  BestOrg.strokeWeight(3);
  BestOrg.noFill();
  BestOrg.rect(0,0,200,200);
  CenterOrg=Env.OList.get(0).CenterOfOrg();
  Env.OList.get(0).DrawO(new PVector(CenterOrg.x-100,CenterOrg.y-100),BestOrg);
  BestOrg.endDraw();
  image(BestOrg, width-(1280-1120), 250,100,100); 
  
  
  //_____________________________________________________________________________________________
  // Sliders
  fill(0);
  float OrgSlideDist=430.0/5000.0;
  OrgSlide.CalcSlide();
  if(OrgSlide.Pos/OrgSlideDist!=CurrentTestDisplay){
    if(OrgSlide.Sliding()){
      CurrentTestDisplay=round(OrgSlide.Pos/OrgSlideDist);
    }else{
      OrgSlide.Pos=CurrentTestDisplay*OrgSlideDist;
    }
  }
  OrgSlide.ChangeText("Org-"+CurrentTestDisplay);
  OrgSlide.Display();
   OrgSlide.Max=floor(Env.OList.size()*OrgSlideDist-1);
   
   
  float GenSlideDist=400/(PastEnvs.size()+1);
  GenSlide.CalcSlide();
  if(GenSlide.Pos/GenSlideDist!=EnvNumber){
    if(GenSlide.Sliding()){
      if(round(GenSlide.Pos/GenSlideDist)!=EnvNumber){
        print("Slid");
        SetEnv(round(GenSlide.Pos/GenSlideDist));
        FillHisto(HistoGram);
      }
    }else{
      GenSlide.Pos=EnvNumber*GenSlideDist;
    }
  }
  GenSlide.ChangeText("Gen-"+EnvNumber);
  GenSlide.Display();
  GenSlide.Max=(PastEnvs.size()-1)*GenSlideDist;
  
  Button Center= new Button(new PVector(200,10),new PVector(60,20),"Center");
   Center.Display(255);
  if(Center.IsPressed()){
    Cam=new PVector(0,0);
  }  
  textSize(30);
  text("Generation "+PastEnvs.size(),105,80);
  textSize(12);
  
  ///_____________________________________________________________________________________________
  //Panel buttons
  PVector PanelPos=new PVector(105,140);//new PVector(105,110);
  fill(255);
  rect(PanelPos.x-5,PanelPos.y,510,60);
  fill(SpeciesColor(Env.OList.get(CurrentTestDisplay).SpeciesNumber()));
  text("Current Species-"+SpeciesName(Env.OList.get(CurrentTestDisplay).SpeciesNumber()),PanelPos.x,PanelPos.y);
  text("Mutability-"+Env.OList.get(CurrentTestDisplay).MuteAmount,300+PanelPos.z,PanelPos.y);
  text("Shows- "+CurrentTestDisplay+"/"+Env.TestList.size(),PanelPos.x,PanelPos.y+20);
  Button Previous= new Button(new PVector(PanelPos.x+15,PanelPos.y+30),new PVector(60,20),"Previous");
  if(CurrentTestDisplay>0){
     //new Button(new PVector(120,140),new PVector(60,20),"Previous").Display();
     Previous.Display(255);
    if(Previous.IsPressed()){
      CurrentTestDisplay--;
      //Env.TestList.remove(0);
      //Env.ShiftToTest(CurrentTestDisplay);
    }  
  }
  Button Next= new Button(new PVector(PanelPos.x+95,PanelPos.y+30),new PVector(60,20),"Next");
  if(CurrentTestDisplay<Env.TestList.size()-1){
    Next.Display(255);
    if(Next.IsPressed()){
      CurrentTestDisplay++;
    }
    if(PlayBackSpeed!=1){
      if(Env.TestList.get(CurrentTestDisplay).Finalized){
        CurrentTestDisplay++;
        Env.TestList.get(CurrentTestDisplay).Reset();
      }
    }
  }
  Button ChangeSpeed= new Button(new PVector(PanelPos.x+95,PanelPos.y+55),new PVector(60,20),"");
  ChangeSpeed.Display(255);
  text("Speed "+PlayBackSpeed,PanelPos.x+100,PanelPos.y+55+15);
  if(ChangeSpeed.IsPressed()){
    PlayBackSpeed*=2;
    if(PlayBackSpeed>100){
      PlayBackSpeed=1;
    }
  }
  
  Button Regen=new Button(new PVector(PanelPos.x+95,PanelPos.y+5),new PVector(60,20),"Regen");
  Regen.Display(255);
  if(Regen.IsPressed()){
      //Env.OList.remove(2);
      for(int i=0; i<100;i++){
        Env.GenNewOrg();
        Env.ShiftToTest(Env.OList.size()-1);
      }
  }
  //new Button(new PVector(200,115),new PVector(60,20),"Regen").Display();
  
  Button Restart=new Button(new PVector(175+PanelPos.x,PanelPos.y+5),new PVector(60,20),"Restart");
  Restart.Display(255);
  if(Restart.IsPressed()){
    //Env.GenNewOrg();
      //Env.ShiftToTest(Env.OList.size()-1);
      Tester T=Env.TestList.get(CurrentTestDisplay);
      //T=new Tester(Env.OList.get(CurrentTestDisplay).CloneOrganism(),Env,60*30);
      T.E=Env;
      T.O=Env.OList.get(CurrentTestDisplay).CloneOrganism();
      T.O.E=Env;
      T.RunTime=60*30;
      T.SetTester();
      T.Finalized=false;
    //Env.ShiftToTest(CurrentTestDisplay);
  }
  Button Mutate=new Button(new PVector(175+PanelPos.x,PanelPos.y+30),new PVector(60,20),"Mutate");
  Mutate.Display(255);
  if(Mutate.IsPressed()){
      Env.OList.get(CurrentTestDisplay).MutateOrg();
      Tester T=Env.TestList.get(CurrentTestDisplay);
      //T=new Tester(Env.OList.get(CurrentTestDisplay).CloneOrganism(),Env,60*30);
      T.E=Env;
      T.O=Env.OList.get(CurrentTestDisplay).CloneOrganism();
      T.O.E=Env;
      T.RunTime=60*30;
      T.SetTester();
      T.Finalized=false;
  }
  Button TestAll =new Button(new PVector(255+PanelPos.x,5+PanelPos.y),new PVector(60,20),"Test all");
  TestAll.Display(255);
  if(TestAll.IsPressed()||frameCount==2){
    Env.TestAll();
    print("Delta time after testall:"+(millis()-LastTime));
  }
  Button Sort =new Button(new PVector(255+PanelPos.x,30+PanelPos.y),new PVector(60,20),"Sort");
  Sort.Display(255);
  if(Sort.IsPressed()){
    Env.SortTests();
  }
  
  Button Reproduce =new Button(new PVector(335+PanelPos.x,5+PanelPos.y),new PVector(60,20),"Nextgen");
  Reproduce.Display(255);
  if(Reproduce.IsPressed()){
    ResetEnv();
    Env.Reproduce();
  }
  
  Button Trim =new Button(new PVector(335+PanelPos.x,30+PanelPos.y),new PVector(60,20),"Trim");
  Trim.Display(255);
  if(Trim.IsPressed()){
    ResetEnv();
    Env.Trim(0.5);
    Env.TestList.clear();
    for(int i=0; i<Env.OList.size();i++){
      Env.ShiftToTest(i);
    }
  }
  
  
   Button QuickGen =new Button(new PVector(415+PanelPos.x,PanelPos.y+5),new PVector(60,20),"FastGen");
  QuickGen.Display(255);
  if(QuickGen.IsPressed()||ALAP){
    ResetEnv();
    Env.QuickGen();
    Env.SetInfo();
    AddEnv(Env);
    FillSpeciesFreq(SpeciesFreq);
    FillHisto(HistoGram);
    print("Delta time after quick Gen:"+(millis()-LastTime));
    //Env.Trim(0.5);
    //Env.TestList.clear();
    //for(int i=0; i<Env.OList.size();i++){
    //  Env.ShiftToTest(i);
    //}
  }
  Button Alap =new Button(new PVector(415+PanelPos.x,30+PanelPos.y),new PVector(60,20),"ALAP");
  if(ALAP){
    Alap.Display(color(255,200,200));
  }else{
    Alap.Display(255);
  }
  if(Alap.IsPressed()){
    ALAP=!ALAP;
  }
  Button ScriptTest =new Button(new PVector(415+PanelPos.x,70+PanelPos.y),new PVector(60,20),"(SCRIPTY GARBAG)");
  ScriptTest.Display(255);
  if(ScriptTest.IsPressed()){
   // print("SCRIPTTEST- OLIst in PastEnvs "+PastEnvs.get(EnvNumber).OList.size());
   //Env.SetInfo();
   print("Current enviroment, species abundance info says there are "+Env.SpeciesAbundanceInfo.size());
  }
  PrevMouse=mousePressed;
  LastTime=millis();
}
void mouseClicked(){
  //Env.OList.get(2).MutateOrg();
  //Env.TestList.remove(0);
  ////Env.OList.remove(2);
  ////Env.GenNewOrg();
  //Env.ShiftToTest(2);
  if(ALAP&&!PrevMouse){
   ALAP=false;
  }
}