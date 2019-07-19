/* Bunch a unbelivably useful functions */

PVector PVadd(PVector A,PVector B){
  return new PVector(A.x+B.x,A.y+B.y);
}
PVector PVextend(PVector A,float B){
  return new PVector(A.x*B,A.y*B);
}

PVector PVlerp(PVector A, PVector B, float l){
 return new PVector(A.x*(1-l)+B.x*l, A.y*(1-l)+B.y*l);
}
PVector PVsetmag(PVector P,float L){
  return PVextend(P,L/PVmag(P));
}
PVector PVminus(PVector P){
  return PVextend(P,-1);
}
float PVmag(PVector P){
  return dist(0,0,P.x,P.y);
}
PVector PVMult(PVector A,PVector B){
  return new PVector(A.x*B.x-A.y*B.y,A.x*B.y+A.y*B.x);
}
PVector PVDivide(PVector P,PVector C){
  return new PVector((C.x*P.x+C.y*P.y)/((C.x*C.x)+(C.y*C.y)),
  (C.x*P.y-C.y*P.x)/((C.x*C.x)+(C.y*C.y)));
}

String PVstring(PVector P){
  return " X:"+ P.x+" Y:"+P.y;
}
float FlLerp(float A,float B, float l){
  return A*(1.0-l)+B*l;
}
float[] FArrayCopy(float[] Arr){
  float[] Copy=new float[Arr.length];
  arrayCopy(Arr,Copy);
  return Copy;
}
Boolean FLtween(float A,float B,float M){
  return ((M>=A)&&(M<=B))||((M<=A)&&(M>=B));
}

int randomInt(int l,int h){
  int Answer=0;
  float Rand= random(l,h+1);
  if(Rand==h+1){
    Answer=h;
  }else{
    Answer=floor(Rand);
  }
  return Answer;
}
int NormalTween(int l, int h, float c, float o){
  int out= floor(randomGaussian()*o+c);
  if((out>h)||(out<l)){
    return NormalTween(l,h,c,o); 
  }
  return out;
}