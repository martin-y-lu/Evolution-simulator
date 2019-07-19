# Evolution-simulator
<strong>Evolution simulator, that simulates creatures that follow physics, and has a simple neural network.</strong>

Made in processing 3.3.4

<b>For an overview, watch the youtube video: https://www.youtube.com/watch?v=GnbQzkmFwA8 </b>
<b> Also: https://youtu.be/27A3XhuI0HA </b>
	

<b>Code- Classes and main functions: Basic overview</b>

Basic functions/classes- file: Functions
  Vector functions- Addition, Scalar multiplication, Lerp, Magnatude, Complex mult and divide
  Other functions- Clamp, Random Integer

Physical objects- file: C_Physical object
  Logic superclass: 

  Point- Baisic piece of phyics.  : Instance of Logic
  Eye- Sensory input- child of Point : Instance of Logic
  Muscle- Connects two points, applies forces, takes input from organism  : Instance of Logic
  Neuron- Connects eyes to logic, logic to logic and to muscles. Has delay in transmittion
  RayCaster- Casts rays, and calulates intersections, distance, ect
  Barrier- Collidable piece of ground
  
 Organism- file: B_Organism
  Organism- The organism class
  
 Enviroment- file A_Enviroment
  Enviroment- Stores Testcases, Library of organisms, and Barriers
  Tester- Tests organisms, evaluates fitness
  
 Main- file: EvolveEngineBinaryCreatures
  Button & Slider - UI
  Camera- Manages the position displayed by everything
  Main Code- Runs the show


<b>More info: Just the video script</b>

Intro- About 3 years ago I saw this simulator made by Cary Kh, that was super cool, so I decided I wanted to make my own. Thus my journey began, to build my own evolution simulator, from scratch.

Much rage, testing, and a few thousand lines of code later, I was left with this. Let’s take a look at what it can do.

Creatures explained-
My processing code simulates organisms that, under physics, move around organically.  Hopefully after a bit of evolution, their movement will be quite fast.
Let’s take a look at how the organisms work.  Organisms are made of points, muscles, eyes, and axons. These parts together let the creatures move rhythmically, and respond to the environment, like many living creatures irl. Let’s see how they do this.

Points build up the body of the organism. They follow physics, being pulled by gravity and colliding with the ground. They also have friction. A darker point means more friction, while a lighter colored point means less.

Muscles hold points together, and let the organism move. Muscles connect two points like a spring, pulling and pushing them towards a target length. Much like springs, muscles can have different strength. A muscle with high strength is like a bone, resisting movement strongly, and is a opaque black. A muscle with less strength is more like a tendon, loosely holding points together, and is more transparent.Muscles also have internal friction, called damping( not so important)

Muscles have two states, like real muscle extension and contraction. These two states have their own target lengths, strengths, and damping. The state of the muscle is controlled by the brain of the organism.

The organism in and of itself is a brain. Everything that makes them has a state, on and off, in and out, extended and contracted. Eyes are the input for the brain, and are a subclass of points. They follow physics and can connect to muscles, but they do not collide with the ground, instead activating(or turning on) when underground 

Axons transmit the activation of the eye to the other parts, such as the muscle, controlling its state. They also have a delay, like real nerves do.

Axons can also connect to points. Points don’t only follow physics, they also have a state. They take input from axons, and sets its own activity using logic gates. The state of the point can also be further transmitted by an axon, essentially making points double as neurons.
There are a few different kind of logic gates. And points take two inputs, and activates when they are both on,  inactive otherwise. Or gates also take two inputs, and activates if at least one of them is on. Not gates only have one input, and returns its opposite. 

Confused? Take a look at this example creature I made. It has a triangular structure made of 3 points and 3 opaque muscles. An eye is suspended by a fourth muscle, and its signal is carried through a chain of axons and logic points, before finally being fed into the muscle holding it up.
Let’s see what happens when we run the simulation.
The eye goes through a rhythmic, continuing motion.Why?  Because, when the eye is above ground, the logic tells the muscle to elongate, and when the eye is underground, the logic tells it to contract, and the cycle continues. Why does the logic do this? It’s because of the not gate.
I hope you can see, that with a few more axons connecting the eye to the other muscles, this rhythmic heartbeat could be used to drive the forward motion of the organism. 

Now this is only one of countless mechanisms that organisms could use to move forward, but I’m not gonna make them by hand. I’ll let the computer do it for me. 5000 randomly generated organisms will be made were just made. Everything about them will be random, the number of points and eyes, their positions, the muscles, their length, strength, and damping, the nerve connections, etc.

Let’s take a look at them. By the way, this is the hub for the simulator. (Montage time) Most organisms flop to the ground, unable to even sustain movement. Some jitter convulsively.Let’s speed this up.
Quite pathetic honestly, but we only just looked at a small fraction of the 5000.

Let’s quickly test all the organisms, running the simulation for a full 50 seconds each. If we run each real time, it would almost 3 days to go through all of them, so we speed it up. It still takes a while to compute though.

Fully tested. To see what organisms did the best, let’s sort them from best to worst, on how far right they went. You’r now seeing the best organism, and the other 9 percentile creatures, down to the worst organism. You can see how quickly the distance they travel drops off from the best.
Let’s take a look at the best organism, it mostly flails, but because of the eye that returns to the ground, it can keep moving. Apparently that’s enough to beat the competition.
Let’s speed it up a bit.
The second best organism has some structure, and kind of uses a front facing foot to step forward.
The third is another flailer.
The fourth has structure like the second, and uses a back facing foot.
And by the fifth organism, just sliding forward without any continuous mechanism was enough.
The sixth has a mechanism, although slow and inefficient. 
Seven is a twitchy one. Unfortunately it has a stray, pointless point, that just kept down its average distance.

Let’s speed it up from now.
You just saw the 50 best creatures, the top one percent, yeah.

Since it’s hard to visualise all of the organisms at once, let’s introduce some graphs. 
This is the histogram, and it shows how well the population did. On the x axis is how far the creatures went. On the y axis is the percent of the creatures that ended up in that range. Basically it tells you how many creatures got how far. The colors on the graph shows the species make up for the organisms that made a distance. 
The species of an organism is determined from the number of points, eyes, muscles and axons. For example, this creature is S-3-2-4-4. Each species has a different color. Basically, the number of points decides the hue, the number of muscles decides the brightness, and the number of eyes and nerves, the saturation.The species and colors, will help visualize how these creatures will evolve, but now, the species make up is just a random rainbow. Also, you can see that most organisms did pretty bad, but that will slowly change when we begin to evolve the creatures.

On that note, Let’s take a look at how evolution works in my simulator. There are always three steps to evolution, just ask Darwin. First is natural selection, where the crappy organisms die, leaving the more favorable ones. 
Before evolution, the population looked like this. I trim the population by randomly killing off the bottom fraction of organisms that did the worst. It’s hard to notice, but the worst creatures were shaved off, as you can see in the histogram.
Then there is reproduction, where the living organisms multiply, spreading their genes and success across the population. In my simulator, I just clone me the best organisms, so they are asexual. The better organisms get more clones than the worse ones, also.
And finally there is mutation, where the organisms are modified slightly, for more opportunities. When the organisms are mutated, new muscles and axons are made, or removed. New points and eyes are made and removed too, but this is less likely. Also, all the properties of muscles, points and axons are slightly changed. These mutations may or may not have made the organism faster, we’ll have to test them again to see.
After all of the three steps, this is what the population looks like. In each step there is a lot of randomness, and that is important to insure variation and give everything a chance, so the histogram is spread out like before, but the average is slowly rising.

These are the organism after one step of evolution. After testing and sorting, it seems that New best is the offspring of best from the last generation, it looks, and acts much like its parent. It’s siblings likely did a lot worse though, because of its chaotic ways.
The next two are from another family we already saw- S 4 1 2. Lets call them the triangle walkers. It’s regular and reliable motion puts it Squarely at the top again
Number 5 is a new one, also getting to the top because of its twitchiness. 
6Where also seen this one before.

Let’s run through a few more generations of evolution. A small breakthrough just occurred, and there are a few more very successful organisms. the best creature is new, and almost uses two backwards facing feet.
The second best is new also. These new creatures tend to use more eyes than the previous generation.
I find the diversity in the creatures fascinating.
Speeding it up.
The previous reigning triangle walkers are still at the top, let’s see how long that lasts.
Org 15- look, it’s the sliding creatures descendants, it figured out how to roll, unfortunately it stopped pretty soon.

Lets keep going. 
Stopping at generation 9, we can see that the  triangle walkers make up a majority of the population now. Their species colour is blue, and as you can see from the large area of blue on the histogram, they are very successful.
A few more things have been changing in the population, that we can see from the other graphs.
This is the generation graph, and it graphs how far the best, worst and median percentile creatures went over the generations. It also shows the species of those organisms. In the first few generation, the light blue flailing creatures did the best, then the darker blue S412 walkers took over, and now even more muscular creatures are taking over, probably because more muscles means more power and control.
Also, 
Above the generation graph, is the species graph, and shows the species make up over the generations.

Despite their ubiquity, they have been overtaken by these large lumbering creatures.s-5 3 26 2 I’m not too sure why though, It might just be because more points means more muscles.

In generation 12 the rollers have taken over again, and now can continuously roll for a long distance. These new creatures are doing a lot better than the triangle walkers, and will probably take over the population.
s-3 4 18 6

Lets just cut to the chase, and see what the creatures are like in 20 generations. The rolling creatures now make up almost all of the population. The best, median and worst are all rolling now . They perfected their movement, by apparently, loosing 2 nerves.Lets take a look at the final creature.

Its honestly not too different, meaning the population stagnated, and isn’t getting much better. This is one of the problems with the simulator. After a while, one species takes over forever, and all variation is done. The creatures aren’t super good at evolving. Since the brain is only binary, any mutation there changes it all up. So when things mutate, they almost always do worse, and there is no genetic drift, witch is bad for variety. And because the population is constant, these crappy, underperforming children just die. Thats why the structure or brain barely changes during evolution. 

This result is not super impressive, but this is only one of the many possible results of evolution. All we have to do is change the random seed, witch changes all the random generation, and we have a whole new different evolution.

Lets go through a few ,more interesting seeds. On the left is the evolution history, and on the right is the best organism.
(Many seeds)

So that is my evolution simulator, Thanks for watching, and let me know what you think!

This was my fist, actually good, youtube video ever, and I hope to make more. I have a bunch o ideas for more evolution simulator videos, like canyon jumping evolution, vertical jump evolution, cooperative evolution, and more. And, by the way, If you have ideas for making the simulator better, comment it below.
Good bye now.
But also, watch cary’s evolution series if you haven’t. They’re crazy well made.
Also, download link in description.



<b> More info again: about new video </b>
Hey everybody, after four months (daym) I’m back with an new update to my evolution simulator, with a bunch of new features. (Btw watch the first video to get up to speed, this video won’t make much sense otherwise)

In order to help the creatures to handle more dangerous and complex environments, I gave the creatures a lot more freedom. Previously the states in the creatures brain were only binary (true or false ), and could only be combined with simple logic gates with 2 inputs. Now the states can range continuously between 1 and negative 1, and can be combined logically by a node with any number of inputs. Points, now take a weighted sum of all its inputs, plus a bias, then passes it into an activation function, witch squishes the sum between -1 and 1 to compute its state. By choosing the correct weights and biases, the point can simulate any logic gate and more. ( watch this video explaining how that works in more detail)

But the most interesting change in my opinion is the creatures input. There eyes now shoot out lasers that measure how far away from the ground by using raycasting and uses that distance as its input. (If an eye is underground, the distance is negative) During mutation, the eyes sensitivity and direction are changed, and the eye may even gain an other laser.

With these new creatures, it is easier for the creatures to gain new inputs and have them effect the internal logic without instantly breaking everything. The simulator now technically uses the NEAT algorithm, with the slight difference that the nerves have a delay and the network allows loops.

Let’s take a look at what these new creatures look like. Welcome back to the evolution hub. Let’s generate 5000 creatures, test them and sort them. The best creature contracts one muscle to move forward. This pulls up the eye, continuing the movement. The next creature flops around, making fine use of its many eyes and muscles. The third creature uses a spinning eye to take a few steps forward. The other creatures also have interesting strategies.

While we evolve the population on flat terrain, lets look at the changes I made to evolution. 
The biggest change I made was slowing evolution way down. Instead of killing off half of the population, i only kill 5%. This means every creature has more chances to show how far they can get. It’s also more like nature, because there isn’t a mass extinction every decade. Another thing I added was density dependent limiting factors, that basically penalises any species with a population over a few hundred. I also penalized species that are too similar to others. I did this to try to increase diversity in the population witch is important for when the population runs into a challenging situation it hasn’t evolved for. Like a bump (SCREAMS) More times than I’m okay with, not a single creature can pass the obstacle, and evolution stops dead. Restricting populations means that there are often 4 or 5 unique species in the first 40 generations.

wait a second. It looks like rolling creature has evolved, just like the last video. Thats a crazy coincidence, I  haven’t gotten any rolling creatures before recording the video, i set the random seed to 100, and lo and behold. Perhaps its destiny. Rolling creatures are to take the promised land. 

Anyway. I also made changes to addition of new points and nerves. Read the wall of text if your interested.

WALL OF TEXT:
	Changes I used:
		When a new nerve is added, the weight used by the logic point is distributed on a normal curve with a low deviation as to not impact the creatures function too much. Then the most helpful weight can be selected via mutation and selection.
		When a new point (Eye or otherwise) is added,  i also connect it to a few points using nerves and muscles (BTW muscles now take more than one input and also do a logic calculation). Previously points were added without muscles, and relied on chance to be attached, witch is kinda useless. Thats why you see a bunch of creatures with dangly bits (ew) after evolution. Maybe it helps with balance, I don’t know.
	Changes I didn’t use: (Most of them lol)
		I used to give creatures that outperformed their parents a lot a large increase in fitness. The problem was that the creatures that flail and just randomly did a lot better tend to live for a long time, witch makes them create alot of flatly offspring, witch then outperform, and before you know it you got a large population of crap creatures. These crap creatures often only have one or two points, and don’t really have an interesting mechanism, relying on luck.
	In order to try to disadvantage creatures that rely on luck, I had a random mutation of all creatures, but that just made the problem worse. yoyle
 I would do anything to kill them.(don’t take out of context)  I could outlaw them, but thats a bit extreme.

So, after 100 generations of evolution, here are the results. The best creature is the perfected version of the first creature we saw. It gallops magestically, wouldn’t you say?

And heres a few more examples. I find it fascinating that most of them are almost bipedal. 

Now lets get to what you were all waiting for, the hurdles. After the first generation…


Past generation 30, the one pointed creatures make up the top 20. Even though it lacks structure, I can respect the way it moves over the hurdles.
The creatures that got overthrown by the single pointed ones are now in 23d place. This is how it moves:



Well, the yellow creatures stayed the reigning creature for the following generations, thats kinda disappointing. I don’t know what I was expecting, because about a third of all the random seeds I tested resulted in a flailing creature. Perhaps the environment is just too challenging for normal creatures. Dispite this seeds falure, lets look at some other results of evolution.

Well, hope you found this video interesting. Tune in next time to watch creatures evolve to jump over Holes! (SCREAM)   Oh yeah, and follow my twitter for updates, and cool stuff. Thanks for watching!



