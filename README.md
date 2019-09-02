# Enzymatic Activity
This automaton models how enzymes catalyze chemical reactions in the human body. Enzymes are proteins that are responsible for joining molecules together and breaking molecules apart. They play a huge role in many cellular processes, such as digestion, nutrient absorption, and synthesis of new tissues. In fact, without enzymes, most chemical reactions in our bodies wouldn’t take place, and life on earth would be very different.

In this automaton, enzymes join smaller molecules (substrates) into bigger molecules (products). As the enzymes do their job, the substrate concentration decreases and the product concentration increases. However, as the product concentration increases, products are more likely to re-bind to enzymes, inhibiting enzymes from joining together substrates. This is called feedback inhibition and is a key method in slowing down enzymatic action when enough product has been produced.

<strong>States of a cell</strong> <br>

In this simulation, different coloured cells represent different types of molecules. The colours are: <br>
● white, representing empty space <br>
● blue, representing a substrate particle <br>
● red, representing an enzyme <br>
● green, representing a product particle <br>
● black, representing an inhibited enzyme <br>
In the first generation, percentages of cells are randomly set to enzymes and substrates, and the rest of the cells are empty space. These percentages can be modified by changing the enzymeSaturation and substrateSaturation variables.

<strong>Evolution rules</strong>
1. If an enzyme is adjacent to two substrates, the substrates join together into a product. If an enzyme is adjacent to more than two substrates, the two affected substrates are chosen randomly

2. If a product is adjacent to an enzyme, the enzyme and product may join together into an inhibited enzyme. The probability of this happening increases as the product concentration increases. If a product is adjacent to more than one enzymes, the affected enzyme is chosen randomly

3. In each generation, all particles move 1 cell in a random direction
