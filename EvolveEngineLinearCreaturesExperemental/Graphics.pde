class Button{
  PVector Pos;
  PVector Size;
  String Text;
  Button(PVector DPos,PVector DSize,String DText){
    Pos=DPos; Size=DSize; Text=DText;
  }
  Boolean IsPressed(){
    return mousePressed&&IsIn();
  }
  Boolean IsIn(){
    return (PrevMouse==false)&&FLtween(Pos.x,Pos.x+Size.x,mouseX)&&FLtween(Pos.y,Pos.y+Size.y,mouseY);
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
class Camera{
 PVector CamPos;
 float Zoom;
 Camera(PVector dCamPos,float dZoom){
  CamPos=dCamPos; Zoom=dZoom;
 }
 
 PVector RealToScreen(PVector RealPos){
  return new PVector(RealToScreenX(RealPos.x),RealToScreenY(RealPos.y));
 }
 float RealToScreenX(float RealPosX){
   return Zoom*(RealPosX-CamPos.x);
 }
 float RealToScreenY(float RealPosY){
   return Zoom*(RealPosY-CamPos.y);
 }
 PVector ScreenToReal(PVector ScreenPos){
   return new PVector(ScreenPos.x/Zoom+CamPos.x,ScreenPos.y/Zoom+CamPos.y);
 }
}

void FillHisto(PGraphics HistoGram){
  float[] Fitnesses= new float[Env.TestList.size()];
    for(int i=0;i<Env.TestList.size();i++){
      float fitness=0.0;
      if(Env.TestList.get(i).Finalized){
        fitness=Env.TestList.get(i).Fitness;
      }
      Fitnesses[i]=fitness;
    }
    float max=max(Fitnesses);
    float min=min(Fitnesses);
    float divSize=2;
    int upperIndex= ceil(max/divSize);
    int lowerIndex= floor(min/divSize);
    int numCol=upperIndex-lowerIndex+1;
    //ArrayList<ArrayList<String>> SpeciesPercentile=new ArrayList<ArrayList<String>>(numCol);
    //while(SpeciesPercentile.size()<numCol){SpeciesPercentile.add(new ArrayList<String>(0));};
    //ArrayList<ArrayList<Integer>> SpeciesFrequency=new ArrayList<ArrayList<Integer>>(numCol);
    //while(SpeciesFrequency.size()<numCol){SpeciesFrequency.add(new ArrayList<Integer>(0));};
    ////SpeciesFrequency.ensureCapacity(numCol);
    //int[] Percentile= new int[numCol];
    //for(int i=0;i<Fitnesses.length;i++){
    //  int index= floor(Fitnesses[i]/divSize)-lowerIndex;
    //  Percentile[index]++;
    //  ArrayList<String> SpName=SpeciesPercentile.get(index);
    //  ArrayList<Integer>SpFreq=SpeciesFrequency.get(index);
    //  Organism TO=Env.TestList.get(i).O;
    //  if(SpName.contains(SpeciesName(TO.SpeciesNumber()))){
    //    int SpeciesIndex=SpName.indexOf(SpeciesName(TO.SpeciesNumber()));
    //    SpFreq.set(SpeciesIndex,SpFreq.get(SpeciesIndex)+1);
    //  }else{
    //    SpName.add(SpeciesName(TO.SpeciesNumber()));
    //    SpFreq.add(1);
    //  }
    //}
    //ArrayList<String[]> SpeciesNameFreq= new ArrayList<String[]>(numCol);
    //while(SpeciesNameFreq.size()<numCol){SpeciesNameFreq.add(new String[0]);};
    //for(int i=0;i<numCol;i++){
    //  String[] NameFreq=new String[SpeciesPercentile.get(i).size()];
    //  for(int s=0;s<NameFreq.length;s++){
    //    NameFreq[s]=SpeciesPercentile.get(i).get(s)+" "+SpeciesFrequency.get(i).get(s);
    //  }
    //  NameFreq=sort(NameFreq);
    //  SpeciesNameFreq.set(i,NameFreq);
    //}
    int[]Percentile=Env.Percentile();
    ArrayList<String[]> SpeciesNameFreq=Env.HistoGramInfo;//HistoGramSpeciesAbundance(min,max,divSize);
    float maxPercent=float(max(Percentile));
    HistoGram.beginDraw();
    HistoGram.background(255);
    HistoGram.noFill();
    HistoGram.stroke(0);
    HistoGram.strokeWeight(2);
    HistoGram.rect(0,0,HistoGram.width,HistoGram.height);
    HistoGram.strokeWeight(1.5);
    //HistoGram.fill(SpeciesColor(Env.OList.get(CurrentTestDisplay).SpeciesNumber()));
    //HistoGram.rect(100,100,20,20);
    PVector BottomLeft= new PVector(20,HistoGram.height-20);
    PVector BottomRight= new PVector(HistoGram.width-20,HistoGram.height-20);
    float Height=HistoGram.height-40;
    float VertScale=Height/maxPercent;
    HistoGram.line(20,HistoGram.height-20,HistoGram.width-20,HistoGram.height-20);
    HistoGram.strokeWeight(1);
    for(int r=0;r<200;r+=5){
      if((r%20)==0){
        HistoGram.stroke(0,40);
      }else{
        HistoGram.stroke(0,18);
      }
      HistoGram.line(20,HistoGram.height-20-VertScale*r,HistoGram.width-20,HistoGram.height-20-VertScale*r);
    }
    for(int c=0;c< Percentile.length;c+=20){
      if((c%20)==0){
        HistoGram.stroke(0,18);
      }else{
        HistoGram.stroke(0,8);
      }
      PVector Bottom= PVlerp(BottomLeft,BottomRight,float(c)/float(Percentile.length));
      HistoGram.line(Bottom.x,Bottom.y,Bottom.x,0);
    }
    
    for(int i=0; i< Percentile.length;i++){
      PVector Bottom= PVlerp(BottomLeft,BottomRight,float(i)/float(Percentile.length));
      //HistoGram.stroke(0);
      //HistoGram.line(Bottom.x,Bottom.y,Bottom.x,Bottom.y-float(Percentile[i])*VertScale);
      float LenUp=0;
      String[] SpNameFreq=new String[SpeciesNameFreq.get(i).length];
      for(int s=0;s<SpNameFreq.length;s++){
        String[] Split=split(SpeciesNameFreq.get(i)[s]," ");
        float NextLenUp=LenUp+Integer.parseInt(Split[1]);
        HistoGram.stroke(SpeciesColor(SpeciesNum(Split[0])));
        HistoGram.line(Bottom.x,Bottom.y-LenUp*VertScale,Bottom.x,Bottom.y-NextLenUp*VertScale);
        LenUp=NextLenUp;
      }
      //HistoGram.stroke(0);
      //HistoGram.line(Bottom.x,Bottom.y,Bottom.x,Bottom.y-float(Percentile[i])*VertScale);
      //HistoGram.fill(0);
      //HistoGram.textSize(10);
      int mod=ceil(((float)Percentile.length)/800.0);
      if(((i+lowerIndex)*divSize/100)%mod==0){
         HistoGram.fill(0);
        HistoGram.text(nf((i+lowerIndex)*divSize/100,0,0),Bottom.x,Bottom.y+15);
      }
    }
    HistoGram.fill(0);
    HistoGram.text(nf(100*maxPercent/float(Fitnesses.length),0,0),2,BottomLeft.y-maxPercent*VertScale);
    HistoGram.endDraw();
}
void FillSpeciesFreq(PGraphics SpecFreq){
    SpecFreq.beginDraw();
    SpecFreq.background(255);
    SpecFreq.noFill();
    SpecFreq.stroke(0);
    SpecFreq.strokeWeight(2);
    SpecFreq.rect(0,0,SpecFreq.width,SpecFreq.height);
    SpecFreq.strokeWeight(1);
    // Draw the Species Abundance graph
    PVector BottomLeft=new PVector(0,60);
    PVector BottomRight=new PVector(SpecFreq.width,60);
    float UpHeight=60;
    float VertScale=UpHeight/NUMORGANISMS;
    
    String[] LargestSpecies=new String[PastEnvs.get(PastEnvs.size()-1).SpeciesAbundanceInfo.size()]; 
    ArrayList<String> BigNames=new ArrayList<String>();
    ArrayList<Float> Fraction=new ArrayList<Float>();
    
    for(int i=0;i<PastEnvs.size();i++){
      PVector Bottom= PVlerp(BottomLeft,BottomRight,float(i)/float(PastEnvs.size()));
      //SpecFreq.stroke(0);
      SpecFreq.noStroke();
      SpecFreq.line(Bottom.x,Bottom.y,Bottom.x,Bottom.y-UpHeight);
      SpecFreq.stroke(0);
      float LenUp=0;
      Enviroment DrawEnv=PastEnvs.get(i);
      println("DrawEnv-"+DrawEnv.SpeciesAbundanceInfo.size()+" different species");
      if(i==PastEnvs.size()-1){// If this gen
        //Find the most populous species
        for(int s=0;s<DrawEnv.SpeciesAbundanceInfo.size();s++){
           String[] Split=split(DrawEnv.SpeciesAbundanceInfo.get(s)," ");
           String num="";
           for(int l=0;l<4-Split[1].length();l++){
             num+="0";
           }
           num+=Split[1];
           LargestSpecies[s]=(num+" "+Split[0]);
        }
        LargestSpecies=sort(LargestSpecies);
        println("LargestSpecies-"+join(LargestSpecies,", "));
        for(int p=0;p<5;p++){//Five largest populations
          if(LargestSpecies.length-1-p>=0){
            String[] Split=split(LargestSpecies[LargestSpecies.length-1-p]," ");
            if(Split.length==2){
              BigNames.add(Split[1]);
              Fraction.add(((float)Integer.parseInt(Split[0]))/NUMORGANISMS);
            }else{
              p--;
            }
          }
        }
        println("BigNames-"+BigNames);
      }
      for(int s=0;s<DrawEnv.SpeciesAbundanceInfo.size();s++){
        String[] Split=split(DrawEnv.SpeciesAbundanceInfo.get(s)," ");
        float NextLenUp=LenUp+Integer.parseInt(Split[1]);
        //print("LenUp "+LenUp);
        //
        SpecFreq.noStroke();
        SpecFreq.fill(SpeciesColor(SpeciesNum(Split[0])));
        SpecFreq.rect(Bottom.x,Bottom.y-LenUp*VertScale,(BottomRight.x-BottomLeft.x)/float(PastEnvs.size()),-float(Integer.parseInt(Split[1]))*VertScale);
        if(i==PastEnvs.size()-1){
          if(BigNames.indexOf(Split[0])!=-1){
            SpecFreq.fill(0);
            SpecFreq.textSize(10);
            SpecFreq.text(nf(Fraction.get(BigNames.indexOf(Split[0]))*100,2,0)+"%",(BottomRight.x-BottomLeft.x)-20,Bottom.y-LenUp*VertScale,(BottomRight.x-BottomLeft.x)/float(PastEnvs.size()));
          }
        }
        //SpecFreq.stroke(SpeciesColor(SpeciesNum(Split[0])));
        //SpecFreq.line(Bottom.x,Bottom.y-LenUp*VertScale,Bottom.x,Bottom.y-NextLenUp*VertScale);
        //SpecFreq.line(Bottom.x+10,Bottom.y-LenUp*VertScale,Bottom.x+50,Bottom.y-LenUp*VertScale);
        LenUp=NextLenUp;
      }
    }
    //Draw the Percentile v Time graph
    BottomLeft=new PVector(0,SpecFreq.height);
    BottomRight=new PVector(SpecFreq.width,SpecFreq.height);
    UpHeight=SpecFreq.height-60;
    
    //1- Get max and min of fitness, and make arrays of names and fitnesses
    ArrayList<String[]> SpecName=new ArrayList<String[]>();
    //while(SpecName.size()<PastEnvs.size()){SpecName.add(new String[0]);};
    ArrayList<float[]> SpecFit=new ArrayList<float[]>();
    //while(SpecFit.size()<PastEnvs.size()){SpecFit.add(new float[0]);};
    float max=0;
    float min=0;
    for(int i=0;i<PastEnvs.size();i++){
      Enviroment PastEnv=PastEnvs.get(i);
      String[] Names=new String[PastEnv.SpeciesFitnessInfo.length];
      float[] Fitness=new float[PastEnv.SpeciesFitnessInfo.length];
      for(int j=0;j<PastEnv.SpeciesFitnessInfo.length;j++){
        String[] Split=split(PastEnv.SpeciesFitnessInfo[j]," ");
        Names[j]=Split[0];
        Fitness[j]=Float.parseFloat(Split[1]);
      }
      if(max(Fitness)>max){
        max=max(Fitness);
      }
      if(min(Fitness)<min){
        min=min(Fitness);
      }
      SpecName.add(Names);
      SpecFit.add(Fitness);
    }
    //2- Find scale
    if(min>0){
      min=0;
    }
    if(max<0){
      max=0;
    }
    float fitHeight=max-min;
    VertScale=UpHeight/fitHeight;
    //3- Draw grid lines
    SpeciesFreq.stroke(0);
    SpeciesFreq.line(0,SpeciesFreq.height+min*VertScale,SpeciesFreq.width,SpeciesFreq.height+min*VertScale);
    //4- Draw lines
    
    int[] strokeWeights={4,3,3,3,2,3,2,3,3,3,4};
    for(int e=0;e<PastEnvs.size()-1;e++){
      float[] thisFit=SpecFit.get(e);
      float[] nFit=SpecFit.get(e+1);
      for(int i=0;i<=10;i++){//Calc percentiles
        int index=floor(float(thisFit.length-1)*float(i)/10.0);
        int indexn=floor(float(nFit.length-1)*float(i)/10.0);
        float x=BottomLeft.x+(BottomRight.x-BottomLeft.x)*(float(e)/float(PastEnvs.size()-1));
        float xn=BottomLeft.x+(BottomRight.x-BottomLeft.x)*(float(e+1)/float(PastEnvs.size()-1));
        float y=(thisFit[index]-min)*VertScale;
        float yn=(nFit[indexn]-min)*VertScale;
        SpeciesFreq.stroke(SpeciesColor(SpeciesNum(SpecName.get(e)[index])));
        SpeciesFreq.strokeWeight(strokeWeights[i]);
        SpeciesFreq.line(x,SpeciesFreq.height-y,xn,SpeciesFreq.height-yn);
        //println("Draws line at fitness:"+thisFit[index]);
      }
    }

    SpeciesFreq.endDraw();
}