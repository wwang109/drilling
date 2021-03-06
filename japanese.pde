qbox [] kanji_mode, score;
qbox dp, restart;
qbox quick_game, option1, option2, option3;
qbox Options, hira, kata, kanji;

game1 match;

boolean game = false, game_setup = false;
boolean answered = false;

int swidth, sheight;

String [] lines;
//menu size
int len = (SCREEN_WIDTH * .8)/3;
int wit = SCREEN_HEIGHT/10; 



void setup() {	
   //menu options
   quick_game = new qbox(SCREEN_WIDTH/10, 0, SCREEN_WIDTH * .8, wit, "Start Game");
   hira = new qbox(SCREEN_WIDTH/10, wit, len, wit, "Hiragana");
   hira.strokes = true;
   kata = new qbox(SCREEN_WIDTH/10 + len, wit, len, wit, "Katakana");
   kanji = new qbox(SCREEN_WIDTH/10 + len*2, wit, len, wit, "Kanji (Not completed)");
   swidth = SCREEN_WIDTH;
   sheight = SCREEN_HEIGHT;   
   //must have game options 
   
   
   score = new qbox[3];
   for(int i = 0; i<3; i++) {
      score[i] = new qbox((SCREEN_WIDTH/3 *2)/3 * i, 0, (SCREEN_WIDTH/3 *2)/3, wit, "");
   }
   restart = new qbox(SCREEN_WIDTH - SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, wit, "Restart");
   
   //init
   
}

void draw() {
   background(1);
   size(SCREEN_WIDTH, SCREEN_HEIGHT);
   fill(250); 
   len = (SCREEN_WIDTH * .8)/3;
   wit = SCREEN_HEIGHT/10;  
   if(game) {
      play_game();
   }
   else{
      if(swidth != SCREEN_WIDTH || sheight != SCREEN_HEIGHT) {
         quick_game.resize(SCREEN_WIDTH/10, 0, SCREEN_WIDTH * .8, wit);
         hira.resize(SCREEN_WIDTH/10, wit, len, wit);
         kata.resize(SCREEN_WIDTH/10 + len, wit, len, wit);
         kanji.resize(SCREEN_WIDTH/10 + len*2, wit, len, wit);       
      }  
      start_menu();
   }
   
}

void play_game() {
   //top menu
   if(swidth != SCREEN_WIDTH || sheight != SCREEN_HEIGHT) {
      for(int i = 0; i<3; i++)
         score[i].resize((SCREEN_WIDTH/3 *2)/3 * i, 0, (SCREEN_WIDTH/3 *2)/3, wit);
      restart.resize(SCREEN_WIDTH - SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, wit);
      match.resize(SCREEN_WIDTH, SCREEN_HEIGHT);
   }   
   textAlign(CENTER, CENTER);
   
   for(int i = 0; i<3; i++) {
      score[i].name = match.text[i];
      score[i].displays();
   }   
   //game data
   restart.displays();
   match.show();

}


void mouseClicked() {
   if(game) {
      if(restart.over())
         game = false;
      match.controls();
   }
   else {
      mouse_click_start();
   }

}

void mouse_click_start() {
   if(hira.over()){
      hira.strokes = true;
      kata.strokes = false;
      kanji.strokes = false;
   }
   if(kata.over()){
      kata.strokes = true;
      hira.strokes = false;
      kanji.strokes = false;
      }
   if(kanji.over()){
      kanji.strokes = false;
      kata.strokes = false;
      hira.strokes = false;
      }
      if(quick_game.over()){
         start_game();
      }      
}

void start_game(){
   lines = null;
   if(hira.strokes){
      lines = loadStrings("hiragana.txt");
   }
   if(kata.strokes){
      lines = loadStrings("katakana.txt");
   }
   if(kanji.strokes){
      for(int i=0,k =0;i<7;i++) {
         if(kanji_mode[i].strokes ==true) {
            if(lines == null)
               lines = loadStrings("kanji_"+ i + ".txt");
            else   
               lines = concat(lines, loadStrings("kanji_"+ i + ".txt"));
         k++;
         }
      }
      if(k==0)
         return; //get out of here if none selected
   }   
      match = new game1(SCREEN_WIDTH, SCREEN_HEIGHT, 6, lines);
      game = true;

}

void start_menu() {
   textAlign(CENTER,CENTER);
   text("OPTIONS", SCREEN_WIDTH/10, wit*2, SCREEN_WIDTH * .8, wit);	
   
   quick_game.displays();
   hira.displays();
   kata.displays();
   kanji.displays();
}


/*
void next_question() {

}
*/
class game1 {
   qbox [] question;
   qbox dp;
   String [] text, lines;
   //true or false when an option has been selected
   bool answered;
   //values for scores and information
   int correct, wrong, rounds, choice;
   
   int box_width;
   int box_length;
   
   game1(int w, int l, int num_choice, String q[]) {
      lines = q;
      choice = num_choice;
      answered = false;
      dp = new qbox(w/10 *3, l/10*2, w * .4, (l/10)*2, "");
      text = new String[3];
      question = new qbox[choice];

      box_width = w/(choice/2);
      box_length = (l/10)*2;   
      int i, j, k=0;
      for(i=0;i<2;i++) {
         for(j=0;j<(choice/2);j++, k++) {
            question[k] = new qbox(j*box_width, (i * box_length) + (l/10) * 6, box_width, box_length, "");
         }
      }
      next_question();
       
   }
   
   void controls() {
      if(answered == true) {
         rounds++;
         answered = false;
         for(int i=0;i<choice;i++)
            question[i].strokes = false;           
         next_question();
      }
      else {   
         for(int j=0;j<choice;j++) {
            if(question[j].over()) {
               //check if answer is correct
               if(question[j].value == dp.value) {
                  correct++;
                  question[j].strokes = true;
                  question[j].currentColor = color(0,200,200);
               }
               else {
                  wrong++;
                  question[j].strokes = true;
                  question[j].currentColor = color(200,50,50);
                  for(i=0;i<choice;i++) {
                     if(question[i].value == dp.value) {
                        question[i].strokes = true;
                        question[i].currentColor = color(0,200,200);                        
                     }
                  }                    
               }
               //change rounds
               answered = true;               			
               return;
            }
         }      
      }
   }
   
   void next_question() {
	//changing word
    int ran = int(random(lines.length));
    //array of num 
    int [] num = new num[choice];
    for(int i=0; i<choice;i++)
      num[i]= 0;
    String [] quest = split(lines[ran], ':');
    //choosing which box question
    int ans = int(random(choice));
    //put answer number into num[] 
	 dp.add(quest);
    int j;
   for(i=0;i<choice;i++){
      num[i] = int(random(lines.length));
      for(j=0;j<i;j++) {
         if(num[j] == num[i] || num[i] == ran){
            num[i] = int(random(lines.length));
            j--;
         }
      }
      qchoice = split(lines[num[i]], ":");
      question[i].add(qchoice);     
   }
   question[ans].add(quest);
   if(kanji.strokes == true)
      reading.name = quest[2];   
   
   }
   
   void show() {
      text[0] = "Correct = " + correct;
      text[1] = "Wrong = " + wrong;
      text[2] = "rounds = " + rounds;   
      dp.display(true);
      
      for(int i=0;i<choice;i++) {
         question[i].display(false);
      }  
      
   }
   
   void resize(int w, int l) {
      dp.resize(w/10 *3, l/10*2, w * .4, l/10*2); 
   
      box_width = w/(choice/2);
      box_length = (l/10)*2;  
      
      int i, j, k=0;
      for(i=0;i<2;i++) {
         for(j=0;j<choice/2;j++, k++) {
            question[k].resize(j*box_width, (i * box_length) + (l/10) * 6, box_width, box_length);
         }
      }      
      
   }


}


class box {
   int x, y;
   int size, sizew;
   String name;
   String [] value;
   boolean strokes;
   color currentColor;
   
   
   boolean overRect(int x, int y, int width, int height) {
      if (mouseX >= x && mouseX <= x+width && 
         mouseY >= y && mouseY <= y+height) {
         return true;
      } 
      else {
         return false;
      }
   }
   void displays() {
      fill(250);
      if(strokes)
         fill(currentColor);
      rect(x, y, size, sizew);
      fill(0, 100, 250);
      
      text(name, x,y, size, sizew);
      noFill();
   }  
}

class qbox extends box
{
   qbox(int ix, int iy, int isize, int isizew, String ival) {
      x = ix;
      y = iy;
      size = isize;
      sizew= isizew;
		name = ival;
      strokes = false;
      currentColor =color(0,50,100);
   }
   
   void resize(int ix, int iy, int isize, int isizew) {
      x = ix;
      y = iy;
      size = isize;
      sizew= isizew;   
   }
   
   void add(String [] ival) {
      value = ival;
   }
   
   void addname(String n) {
      name = n;
   }
   
   boolean over() {
      return overRect(x, y, size, sizew);
   }
   void display(boolean s) {
      fill(255);
      if(strokes)
         fill(currentColor);      
      rect(x, y, size, sizew);
      fill(0, 100, 250);
	  //possible option to switch them
	  textSize(25);
	  if(s)
		text(value[0], x, y, size, sizew);
     else
		text(value[1], x, y, size, sizew);
      textSize(12);
      noFill();
   }
 
} 

