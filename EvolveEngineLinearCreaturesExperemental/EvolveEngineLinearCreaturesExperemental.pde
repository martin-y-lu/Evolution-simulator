import java.util.*;
//Current enviroment
Enviroment Env= new Enviroment();
int NUMORGANISMS=5000;
float RUNTIME=15;//Seconds
int SEED=108;

//Enviroment handler
int EnvNumber=0;
ArrayList<Enviroment> PastEnvs=new ArrayList<Enviroment>();
boolean PrevMouse=false;
int LastTime = 0;

//Graphics
Camera Cam=new Camera(new PVector(-50,-600),0.9);
PGraphics MainScreen;
PGraphics HistoGram;
PGraphics SpeciesFreq;
PGraphics BestOrg;
PGraphics MedianOrg;
PGraphics WorstOrg;
PGraphics OrgGraphic;

//Sliders (Unlike buttons they need variables)
Slider OrgSlide=new Slider(new PVector(100,100),"Org-",0,10);
Slider GenSlide=new Slider(new PVector(100,230),"Gen-",0,10);

//Display Information 
int ScreenNumber=0; //0 is MainScreen, 1 is OverviewScreen
int CurrentTestDisplay=0;
int CurrentEnv=0;
int PlayBackSpeed=1;
boolean ALAP=false;
boolean FollowOrg=false;
boolean OverviewOrgs=true;


//NOTEPAD SUIE
Ray RayCast;

void setup(){
  randomSeed(SEED);
  //Seeds with interesting stuffs
  //size(1280, 720);
  fullScreen();
  frameRate(60);
  //IHWEiufg
   RayCast= new Ray(new PVector(0,0),new PVector(-50,10));
   
  //Set up Graphics
  HistoGram=createGraphics(400,200,JAVA2D);
  SpeciesFreq=createGraphics(510,260,JAVA2D);//createGraphics(510,60);
  WorstOrg=createGraphics(200,200,JAVA2D);
  MedianOrg=createGraphics(200,200,JAVA2D);
  BestOrg=createGraphics(200,200,JAVA2D);
  MainScreen=createGraphics(width,height,JAVA2D);
  OrgGraphic=createGraphics(width,height,JAVA2D);
  OrgGraphic.beginDraw(); 

  
  //Set up enviroment  
  Env.SetSummonArea(new PVector(0,100),new PVector(200,200));
  Env.SetLiveArea(new PVector(-1000,-1000),new PVector(20000,1800));
  Env.OList.add(new Organism());
  //Env.OList.get(0).PList.add(new Point(new PVector(100,130),new PVector(0,0),1,0.2,new float[]{10},-5,new float[]{0}));
  //Env.OList.get(0).PList.add(new Point(new PVector(200,130),new PVector(0,0),5,0.2,new float[]{10},-5,new float[]{0}));
  //Env.OList.get(0).PList.add(new Point(new PVector(150,80),new PVector(0,0),5,0.2,new float[]{1},0,new float[]{0}));
  //Env.OList.get(0).PList.add(new Eye(new PVector(150,130),new PVector(0,0),5,0.2,new PVector(0,40)));
  ////Env.OList.get(0).PList.add(new Eye(new PVector(150,130),new PVector(0,0),8));
 //// Env.OList.get(0).PList.add(new Logic(new PVector(30,130),new PVector(0,0),1,0,new boolean[]{true}));
  //Env.OList.get(0).MList.add(new Muscle(0,1,new float[]{.4,110,.2},new float[]{1,160,.2},new float[]{1},0.5,new float[]{0}));
  //Env.OList.get(0).MList.add(new Muscle(1,2,new float[]{.4,110,.2},new float[]{1,160,.2},new float[]{1},0.5,new float[]{0}));
  //Env.OList.get(0).MList.add(new Muscle(2,0,new float[]{.4,110,.2},new float[]{1,160,.2},new float[]{1},0.5,new float[]{0}));
  //Env.OList.get(0).MList.add(new Muscle(2,3,new float[]{1,80,.2},new float[]{1,120,.2},new float[]{10},-5,new float[]{0}));
  //Env.OList.get(0).NList.add(new Nerve(3,false,0,15));
  ////Env.OList.get(0).NList.add(new Nerve(4,false,0,30));
  //Env.OList.get(0).NList.add(new Nerve(0,false,1,15));
  //Env.OList.get(0).NList.add(new Nerve(1,true,3,30));
  
    Env.OList.get(0).PList.add(new Point(new PVector(100,130),new PVector(0,0),1,0.2,new float[]{},-5,new float[]{}));
  Env.OList.get(0).PList.add(new Point(new PVector(200,130),new PVector(0,0),5,0.2,new float[]{},-5,new float[]{}));
  Env.OList.get(0).PList.add(new Point(new PVector(150,80),new PVector(0,0),5,0.2,new float[]{},0,new float[]{}));
  ArrayList<PVector> EyeDir=new ArrayList<PVector>();
  EyeDir.add(new PVector(40,20));
  Env.OList.get(0).PList.add(new Eye(new PVector(150,130),new PVector(0,0),5,0.2,EyeDir,new float[]{20},0));
  //Env.OList.get(0).PList.add(new Eye(new PVector(150,130),new PVector(0,0),8));
 // Env.OList.get(0).PList.add(new Logic(new PVector(30,130),new PVector(0,0),1,0,new boolean[]{true}));
  Env.OList.get(0).MList.add(new Muscle(0,1,new float[]{.4,110,.2},new float[]{1,160,.2},new float[]{},0.5,new float[]{}));
  Env.OList.get(0).MList.add(new Muscle(1,2,new float[]{.4,110,.2},new float[]{1,160,.2},new float[]{},0.5,new float[]{}));
  Env.OList.get(0).MList.add(new Muscle(2,0,new float[]{.4,110,.2},new float[]{1,160,.2},new float[]{},0.5,new float[]{}));
  Env.OList.get(0).MList.add(new Muscle(2,3,new float[]{1,80,.2},new float[]{1,120,.2},new float[]{},-5,new float[]{}));
  Env.OList.get(0).NList.add(new Nerve(3,false,0,15));
  //Env.OList.get(0).NList.add(new Nerve(4,false,0,30));
  Env.OList.get(0).NList.add(new Nerve(0,false,1,15));
  Env.OList.get(0).NList.add(new Nerve(1,true,3,30));
  Env.OList.get(0).SetVars();
  Env.OList.get(0).FixNewOrg();
  
  Env.OList.add(new Organism());
  Env.OList.get(1).PList.add(new Point(new PVector(150,81),new PVector(0,0),1,0.2,new float[]{1},0,new float[]{0}));
  Env.OList.get(1).PList.add(new Point(new PVector(151,80),new PVector(0,0),1,0.2,new float[]{1},0,new float[]{0}));
  Env.OList.get(1).PList.add(new Point(new PVector(150,82),new PVector(0,0),1,0.2,new float[]{1},0,new float[]{0}));
  Env.OList.get(1).MList.add(new Muscle(0,1,new float[]{.4,110,.2},new float[]{1,160,.2},new float[]{1},0,new float[]{0}));
  Env.OList.get(1).MList.add(new Muscle(1,2,new float[]{.4,110,.2},new float[]{1,160,.2},new float[]{1},0,new float[]{0}));
  Env.OList.get(1).MList.add(new Muscle(2,0,new float[]{.4,110,.2},new float[]{1,160,.2},new float[]{1},0,new float[]{0}));
  Env.OList.get(1).NList.add(new Nerve(0,true,1,15)); 
  Env.OList.get(1).NList.add(new Nerve(1,true,2,15));
  Env.OList.get(1).NList.add(new Nerve(2,true,0,15));
  Env.OList.get(1).SetVars();
 
  //Env.BList.add(new Barrier(new PVector(-2000,300),new PVector(10000,0),.2,.1));
  
  Env.SetVars();
  Env.ShiftToTest(0);
  Env.ShiftToTest(1);
 
 //Flat
 Env.BList.add(new Barrier(new PVector(-300,300),new PVector(2000+4000,0),.2,.05));
 
 //Gaps
  //int init=400;
  //int size=250;
  //int gap=30;
  //int depth=10;
  // Env.BList.add(new Barrier(new PVector(-800,300),new PVector(800+init,0),.2,.05));
  //Env.BList.add(new Barrier(new PVector(init,300),new PVector(0,depth),.2,.05));
  //while( init<2500){
    
  //   Env.BList.add(new Barrier(new PVector(init,300+depth),new PVector(gap,0),.2,.05));
  //   init+=gap;
  //  Env.BList.add(new Barrier(new PVector(init,300),new PVector(size,0),.2,.05));
  //  Env.BList.add(new Barrier(new PVector(init,300+depth),new PVector(0,-depth),.2,.05));
     
  //  depth+=(int)(gap*0.4);
  //  depth+=6; 
    
  //   Env.BList.add(new Barrier(new PVector(init+size,300),new PVector(0,depth),.2,.05));
  //  init+=size;
  //  gap+=10;
  //  gap+=5+(int)(gap*0.3);
  //  if(gap>130){
  //    gap=130; 
  //  }
    
  //  size+=20;
  //  if(size>400){
  //    size=400; 
  //  }
  //}
  
  //Hurdles
  //int init=400;
  //int size=300;
  //int Width=30;
  //int Height=5;
  //Env.BList.add(new Barrier(new PVector(-800,300),new PVector(800+init,0),.2,.05));
  //Env.BList.add(new Barrier(new PVector(init,300),new PVector(0,-Height),.2,.05));
  //while( init<2500){
    
  //   Env.BList.add(new Barrier(new PVector(init,300-Height),new PVector(Width,0),.2,.05));
  //   init+=Width;
  //  Env.BList.add(new Barrier(new PVector(init,300),new PVector(size,0),.2,.05));
  //  Env.BList.add(new Barrier(new PVector(init,300-Height),new PVector(0,Height),.2,.05));
     
  //  Height+=10;
  //  if(Height>40){
  //   Height=35;
  //  }
    
  //  Env.BList.add(new Barrier(new PVector(init+size,300),new PVector(0,-Height),.2,.05));
  //  init+=size;
  //}
  
  ////Climb
  //int stepX=400;
  //int jumpX=20;
  //int jumpY=2;
  //int X=-580;
  //int Y=340;
  //while(X<4000){
  //  if(stepX>100){
  //     stepX+=-20; 
  //  }
  //  if(jumpY>-40){
  //    jumpY+=-3;
  //  }  
  //  Env.BList.add(new Barrier(new PVector(X,Y),new PVector(stepX,0),.2,.05));
  //  X+=stepX;
  //  Env.BList.add(new Barrier(new PVector(X,Y),new PVector(jumpX,jumpY),.2,.05));
  //  X+=jumpX;
  //  Y+=jumpY;
  //}
  
  
  for(int i=0;i<50;i++){
    print(ceil(abs(randomGaussian()*0.5)));
  }
}


void RunMainScreen(PGraphics MainScreen,PGraphics HistoGram,PGraphics SpeciesFreq,PGraphics BestOrg,PGraphics MedianOrg,PGraphics WorstOrg){
  //_____________________________________________________________________________________________
  // Main screen draw, enviroment draw & Update
  MainScreen.beginDraw();
  MainScreen.background(255,255,255);
  Env.DrawBackground(Cam,MainScreen);
  
 

  //Env.UpdateOrg(0);
  // Env.TestList.get(0).PList.get(4).Pos=new PVector(mouseX+Cam.x,mouseY+Cam.y);
  if(CurrentTestDisplay>=Env.TestList.size()){
    CurrentTestDisplay=Env.TestList.size()-1;
  }
  for(int i=0;i<PlayBackSpeed;i++){
     Env.TestList.get(CurrentTestDisplay).RunTest();
  }
  MainScreen.textSize(12);
  MainScreen.text("Time-"+Env.TestList.get(CurrentTestDisplay).time,20,50);
  MainScreen.text("delta Time-"+(millis()-LastTime),width-100,20);
  if(Env.TestList.get(CurrentTestDisplay).Finalized){
    MainScreen.text("Fitness-"+Env.TestList.get(CurrentTestDisplay).Fitness,20,60);
  }
  
  MainScreen.fill(140,170,255);
  MainScreen.rect(Cam.RealToScreenX(Env.SummonPos.x),Cam.RealToScreenY(Env.SummonPos.y),Env.SummonRect.x*Cam.Zoom,Env.SummonRect.y*Cam.Zoom);
  Env.DrawGround(Cam,MainScreen);
  if(OverviewOrgs){
    for(int i=0;i<Env.OList.size();i+=ceil(Env.OList.size()/10.0)){//10.0
      OrgGraphic.beginDraw();
      OrgGraphic.background(255,0);
      Env.DrawOrg(i,Cam,OrgGraphic);
      PVector OrgCenter=Env.TestList.get(i).O.CenterOfOrg();
      OrgGraphic.fill(SpeciesColor(Env.TestList.get(i).O.SpeciesNumber()));
      OrgGraphic.stroke(0);
      OrgGraphic.triangle(Cam.RealToScreenX(OrgCenter.x),100,Cam.RealToScreenX(OrgCenter.x)-20,50,Cam.RealToScreenX(OrgCenter.x)+20,50);
      OrgGraphic.endDraw();
      //OrgImg=OrgGraphic.get();
      MainScreen.tint(255,100);
      MainScreen.image(OrgGraphic,0,0);
    }
  }
  MainScreen.fill(255);
  MainScreen.stroke(0);
  MainScreen.strokeWeight(2);
  PVector OrgCenter=Env.TestList.get(CurrentTestDisplay).O.CenterOfOrg();
  MainScreen.triangle(Cam.RealToScreenX(OrgCenter.x),100,Cam.RealToScreenX(OrgCenter.x)-20,50,Cam.RealToScreenX(OrgCenter.x)+20,50);
  Env.DrawOrg(CurrentTestDisplay,Cam,MainScreen);// Draw current organism.
  MainScreen.textSize(12);
  MainScreen.fill(0);
  MainScreen.text(mouseX+" "+mouseY,10,10);
  MainScreen.text("Camera-"+ Cam.CamPos.x+" "+Cam.CamPos.y+" Zoom-"+Cam.Zoom,10,20);
  if(Cam.Zoom>0.6){
    MainScreen.textSize(24);
  }else{
    MainScreen.textSize(24*Cam.Zoom/0.6);
  }
  
  //Numbers
  for(float i=Cam.CamPos.x-100;i<Cam.CamPos.x+width/Cam.Zoom;i+=100){
    i= ceil(i/100.0)*100; //round up 100
    
    MainScreen.stroke(0);
    MainScreen.strokeWeight(1);
    MainScreen.line(Cam.RealToScreenX(i),height,Cam.RealToScreenX(i),height-50);
    MainScreen.text(floor(i/100),Cam.RealToScreenX(i)+5,height-30);
  }
  
  
  
  
  //MainScreen.fill(0);
  //MainScreen.ellipse(Cam.RealToScreenX(RayCast.Pos.x),Cam.RealToScreenY(RayCast.Pos.y),10,10);
  
  //MainScreen.line(Cam.RealToScreenX(RayCast.Pos.x),Cam.RealToScreenY(RayCast.Pos.y),Cam.RealToScreenX(RayCast.Pos.x+RayCast.Dir.x),Cam.RealToScreenY(RayCast.Pos.y+RayCast.Dir.y));
  
  //RayCast.Pos= Cam.ScreenToReal(new PVector(mouseX,mouseY));
  
  //MainScreen.text(RayCast.RayValue(Env.BList),Cam.RealToScreenX(RayCast.Pos.x),Cam.RealToScreenY(RayCast.Pos.y));
  //if( RayCast.Intersects(Env.BList)){
    
  //  PVector Intersect= RayCast.IntersectPoint(Env.BList);
  //  MainScreen.ellipse(Cam.RealToScreenX(Intersect.x),Cam.RealToScreenY(Intersect.y),10,10);
  //}
  MainScreen.endDraw();
  //tint(255,255);
  image(MainScreen,0,0);
  
  
  //_____________________________________________________________________________________________
  //Draw HistoGram and Species Percent graphs
  Button DrawHisto= new Button(new PVector(280+80,10),new PVector(60,20),"Graphs");
  DrawHisto.Display(255);
  if(DrawHisto.IsPressed()){  
    ResetEnv();
    Env.SetInfo();
    FillSpeciesFreq(SpeciesFreq);
    FillHisto(HistoGram);
    //AddEnv(Env);
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
  Env.OList.get(worst).DrawO(new Camera(new PVector(CenterOrg.x-100,CenterOrg.y-100),1),WorstOrg);
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
  Env.OList.get(median).DrawO(new Camera(new PVector(CenterOrg.x-100,CenterOrg.y-100),1),MedianOrg);
  MedianOrg.endDraw();
  image(MedianOrg, width-(1280-970), 250,100,100); 
  
  
  BestOrg.beginDraw();
  BestOrg.background(200,220,255);
  
  BestOrg.stroke(0);
  BestOrg.strokeWeight(3);
  BestOrg.noFill();
  BestOrg.rect(0,0,200,200);
  CenterOrg=Env.OList.get(0).CenterOfOrg();
  Env.OList.get(0).DrawO(new Camera(new PVector(CenterOrg.x-100,CenterOrg.y-100),1),BestOrg);
  BestOrg.endDraw();
  image(BestOrg, width-(1280-1120), 250,100,100); 
  
  
  //_____________________________________________________________________________________________
  // Sliders
  fill(0);
  float OrgSlideDist=430.0/NUMORGANISMS;
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
        int prevsize=Env.OList.size();
        SetEnv(round(GenSlide.Pos/GenSlideDist));
        CurrentTestDisplay=floor(CurrentTestDisplay*Env.OList.size()/prevsize);
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
    Cam.CamPos=new PVector(0,0);
  }  
  Button Follow= new Button(new PVector(200+80,10),new PVector(60,20),"Follow");
  if(FollowOrg){
     Follow.Display(color(255,200,200));
     float FollowRate=0.1;
     PVector Target=PVadd(Env.TestList.get(CurrentTestDisplay).O.CenterOfOrg(),PVextend(new PVector(-width*3/4.0,-height*3/4.0),1.0/Cam.Zoom));
     Cam.CamPos= PVlerp(Cam.CamPos,Target,FollowRate);
  }else{
    Follow.Display(255);
  }
  //Follow.Display(255);
  if(Follow.IsPressed()){
    FollowOrg=!FollowOrg;
  }  
  Button Overview= new Button(new PVector(200+3*80,10),new PVector(60,20),"Overview");
  if(OverviewOrgs){
     Overview.Display(color(255,200,200));
  }else{
    Overview.Display(255);
  }
  if(Overview.IsPressed()){
    OverviewOrgs=!OverviewOrgs;
  }
  Button ZoomIn= new Button(new PVector(20,80),new PVector(20,20),"+");
  ZoomIn.Display(255);
  if(ZoomIn.IsPressed()){
    Cam.Zoom*=1.2;
  }
  Button ZoomOut= new Button(new PVector(50,80),new PVector(20,20),"-");
  ZoomOut.Display(255);
  if(ZoomOut.IsPressed()){
    Cam.Zoom/=1.2;
  }
  Button Up= new Button(new PVector(35,105),new PVector(20,20),"^");
  Up.Display(255);
  Button Left= new Button(new PVector(15,125),new PVector(20,20),"<");
  Left.Display(255);
  Button Right= new Button(new PVector(55,125),new PVector(20,20),">");
  Right.Display(255);
  Button Down= new Button(new PVector(35,145),new PVector(20,20),"v");
  Down.Display(255);
  float Step=12;
  if(Up.IsIn()){
    Cam.CamPos.y-=Step;
  }if(Down.IsIn()){
    Cam.CamPos.y+=Step;
  }if(Left.IsIn()){
    Cam.CamPos.x-=Step;
  }if(Right.IsIn()){
    Cam.CamPos.x+=Step;
  }
  
  textSize(30);
  text("Generation "+PastEnvs.size(),105,80);
  textSize(14);
  
  ///_____________________________________________________________________________________________
  //Panel buttons
  PVector PanelPos=new PVector(105,160);//new PVector(105,110);
  fill(255);
  rect(PanelPos.x-5,PanelPos.y-20,510,80);
  Button Previous= new Button(new PVector(PanelPos.x+15,PanelPos.y+30),new PVector(60,20),"Previous");
  if(CurrentTestDisplay>0){
     //new Button(new PVector(120,140),new PVector(60,20),"Previous").Display();
     Previous.Display(255);
    if(Previous.IsPressed()){
      CurrentTestDisplay--;
      Env.TestList.get(CurrentTestDisplay).Reset();
      println("Current Display Back one");
      //Env.TestList.remove(0);
      //Env.ShiftToTest(CurrentTestDisplay);
    }  
  }
  Button Next= new Button(new PVector(PanelPos.x+95,PanelPos.y+30),new PVector(60,20),"Next");
  if(CurrentTestDisplay<Env.TestList.size()-1){
    Next.Display(255);
    if(Next.IsPressed()){
      CurrentTestDisplay++;
      println("Current Display Forward one");
    }
    if(PlayBackSpeed>4){
      if(Env.TestList.get(CurrentTestDisplay).Finalized){
        CurrentTestDisplay++;
        Env.TestList.get(CurrentTestDisplay).Reset();
      }
    }
  }
  fill(SpeciesColor(Env.OList.get(CurrentTestDisplay).SpeciesNumber()));//Glitcgung
  if(Env.SpeciesAbundanceDict.containsKey(Env.OList.get(CurrentTestDisplay).Name())){
         text("Current Species Pop:"+Env.SpeciesAbundanceDict.get(Env.OList.get(CurrentTestDisplay).Name()),PanelPos.x,PanelPos.y-20);
  }
  text("Current Species Related Pop:"+Env.RelatedPopulation(Env.OList.get(CurrentTestDisplay).Name()),PanelPos.x+180,PanelPos.y-20);
  
  text("Current Species-"+SpeciesName(Env.OList.get(CurrentTestDisplay).SpeciesNumber()),PanelPos.x,PanelPos.y);
  text("Mutability-"+nf(Env.OList.get(CurrentTestDisplay).MuteAmount,1,2),190+PanelPos.x,PanelPos.y);
  text("Fitness-"+floor( Env.TestList.get(CurrentTestDisplay).EvaluateSkill()),300+PanelPos.x,PanelPos.y);
  text("Parent Fit-"+floor(Env.TestList.get(CurrentTestDisplay).ParentFitness),400+PanelPos.x,PanelPos.y);
  text("Shows- "+CurrentTestDisplay+"/"+Env.TestList.size(),PanelPos.x,PanelPos.y+20);
  Button ChangeSpeed= new Button(new PVector(PanelPos.x+95,PanelPos.y+55),new PVector(60,20),"");
  ChangeSpeed.Display(255);
  text("Speed "+PlayBackSpeed,PanelPos.x+100,PanelPos.y+55+15);
  if(ChangeSpeed.IsPressed()){
    PlayBackSpeed*=2;
    if(PlayBackSpeed>200){
      PlayBackSpeed=1;
    }
  }
  
  Button Regen=new Button(new PVector(PanelPos.x+95,PanelPos.y+5),new PVector(60,20),"Regen");
  Regen.Display(255);
  if(Regen.IsPressed()){
      //Env.OList.remove(2);
      for(int i=0; i<NUMORGANISMS;i++){
        Env.GenNewOrg();
        Env.ShiftToTest(Env.OList.size()-1);
      }
  }
  
  Button Restart=new Button(new PVector(175+PanelPos.x,PanelPos.y+5),new PVector(60,20),"Restart");
  Restart.Display(255);
  if(Restart.IsPressed()){
    //Env.GenNewOrg();
      //Env.ShiftToTest(Env.OList.size()-1);
      //Tester T=Env.TestList.get(CurrentTestDisplay);
      //T.Reset();
      Env.TestList.get(CurrentTestDisplay).Reset();
      //T=new Tester(Env.OList.get(CurrentTestDisplay).CloneOrganism(),Env,60*30);
      //T.E=Env;
      //T.O=Env.OList.get(CurrentTestDisplay).CloneOrganism();
      //T.O.E=Env;
      //T.RunTime=60*30;
      //T.SetTester();
      //T.Finalized=false;
    //Env.ShiftToTest(CurrentTestDisplay);
  }
  Button Mutate=new Button(new PVector(175+PanelPos.x,PanelPos.y+30),new PVector(60,20),"Mutate");
  Mutate.Display(255);
  if(Mutate.IsPressed()){
      //Env.OList.get(CurrentTestDisplay).MutateOrg();
      Env.TestList.get(CurrentTestDisplay).MutateTester();
      Env.TestList.get(CurrentTestDisplay).Reset();
      //Tester T=Env.TestList.get(CurrentTestDisplay);
      ////T=new Tester(Env.OList.get(CurrentTestDisplay).CloneOrganism(),Env,60*30);
      //T.E=Env;
      //T.O=Env.OList.get(CurrentTestDisplay).CloneOrganism();
      //T.O.E=Env;
      //T.RunTime=60*30;
      //T.SetTester();
      //T.Finalized=false;
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
    Env.Trim(0.6);
    Env.ReshiftToTest();
    //for(int i=0; i<Env.OList.size();i++){
    //  Env.ShiftToTest(i);
    //}
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
    PVector Target=PVadd(Env.TestList.get(CurrentTestDisplay).O.CenterOfOrg(),PVextend(new PVector(-width*3/4.0,-height*3/4.0),1.0/Cam.Zoom));
    Cam.CamPos=Target;
  }
  
  Button Alap =new Button(new PVector(415+PanelPos.x,30+PanelPos.y),new PVector(60,20),"ALAP");
  if(ALAP){
    Alap.Display(color(255,200,200));
  }else{
    Alap.Display(255);
  }
  if(Alap.IsPressed()){
    ALAP=!ALAP;
    OverviewOrgs=true;
  }
  Button ScriptTest =new Button(new PVector(415+PanelPos.x,70+PanelPos.y),new PVector(60,20),"(SCRIPTY GARBAG)");
  ScriptTest.Display(255);
  if(ScriptTest.IsPressed()){
   // print("SCRIPTTEST- OLIst in PastEnvs "+PastEnvs.get(EnvNumber).OList.size());
   //Env.SetInfo();
   //print("Current enviroment, species abundance info says there are "+Env.SpeciesAbundanceInfo.size());
   //println("TestList size-"+Env.TestList.size());
   //println("CurrentTestDisplay-"+CurrentTestDisplay);
    //int NumOrganisms=5000;
    ////  Trim+ Power function distribution
    //float trim=0.4;
    //float Power=0.3;
    //float SurvFract=0.90;
    //float Multiplier=SurvFract*(Power+1)/pow(1-trim,Power+1);
    //int PrevSize=Env.OList.size()-1;
    //for(int i=0; i<PrevSize;i++){
    //  float rank=lerp(0,1-trim,1-(float)i/PrevSize);
    //  int numOffspring=round(randomGaussian()*0.5+Multiplier*pow(rank,Power));//abs(round(randomGaussian()*(pow(rank,2)*2.7)))+1;
    //  for(int j=0; j<numOffspring;j++){
    //    Organism MutatedClone=Env.OList.get(i).CloneOrganism();
    //    MutatedClone.E=Env;
    //    MutatedClone.MutateOrg();
    //    Env.OList.add(MutatedClone);
    //  }
    //}
    //int targSize=Env.OList.size()-PrevSize;
    //while(Env.OList.size()>targSize){
    //  Env.OList.remove(Env.OList.size()-1);
    //}
    //Env.ReshiftToTest();
    //print(Env.SpeciesAbundance());
  }
  
  
  
  
}
void draw(){
  if(ScreenNumber==0){
    RunMainScreen(MainScreen,HistoGram, SpeciesFreq, BestOrg, MedianOrg, WorstOrg);
  }else if(ScreenNumber==1){
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
   OverviewOrgs=false;
  }
}