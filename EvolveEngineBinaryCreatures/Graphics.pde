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
    HistoGram.strokeWeight(1);
    //HistoGram.fill(SpeciesColor(Env.OList.get(CurrentTestDisplay).SpeciesNumber()));
    //HistoGram.rect(100,100,20,20);
    PVector BottomLeft= new PVector(20,HistoGram.height-20);
    PVector BottomRight= new PVector(HistoGram.width-20,HistoGram.height-20);
    float Height=HistoGram.height-40;
    float VertScale=Height/maxPercent;
    HistoGram.line(20,HistoGram.height-20,HistoGram.width-20,HistoGram.height-20);
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
      if(((i+lowerIndex)*divSize/100)%1==0){
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
    float VertScale=UpHeight/5000.0;
    for(int i=0;i<PastEnvs.size();i++){
      PVector Bottom= PVlerp(BottomLeft,BottomRight,float(i)/float(PastEnvs.size()));
      SpecFreq.stroke(0);
      SpecFreq.line(Bottom.x,Bottom.y,Bottom.x,Bottom.y-UpHeight);
      float LenUp=0;
      Enviroment DrawEnv=PastEnvs.get(i);
      print("DrawEnv-"+DrawEnv.SpeciesAbundanceInfo.size()+" different species");
      for(int s=0;s<DrawEnv.SpeciesAbundanceInfo.size();s++){
        String[] Split=split(DrawEnv.SpeciesAbundanceInfo.get(s)," ");
        float NextLenUp=LenUp+Integer.parseInt(Split[1]);
        //print("LenUp "+LenUp);
        //
        SpecFreq.noStroke();
        SpecFreq.fill(SpeciesColor(SpeciesNum(Split[0])));
        SpecFreq.rect(Bottom.x,Bottom.y-LenUp*VertScale,(BottomRight.x-BottomLeft.x)/float(PastEnvs.size()),-float(Integer.parseInt(Split[1]))*VertScale);
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
        SpeciesFreq.line(x,SpeciesFreq.height-y,xn,SpeciesFreq.height-yn);
        println("Draws line at fitness:"+thisFit[index]);
      }
    }

    SpeciesFreq.endDraw();
}