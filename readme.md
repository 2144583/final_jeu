# Presentation Eye of the toaster
    -Louis-Philippe L'Ecuyer

Eye of the Toaster est un roguelite survival de manches incrementiel ou les ennemis tout comme le joueur peuvent evoluer de facon exponentielle. Les ennemis donnent de l'exp a leur mort, ce qu'il permet au joueur de monter de niveau et pour chaque niveau acquerit durant une manche, le joueur pourra choisir une amelioration. Le but est de survivre le plus longtemps possible sans mourrir.

Pour ce projet, mon inspiration principale est le jeu egalement fait en GDScript Brotato, l'idee de gestion d'armes multiples est directement prise de ce jeu.

Mon but etait de recreer ma propre version de Brotato en essayant d'etre le plus fidele possible au jeu de base tout en etant contraint par un delai plus limité.

## Systeme D'amelioration

Comme dans Brotato, Eye of the Toaster offre des ameliorations de joueur affichees aleatoirement selon un systeme de rarete. Les ameliorations vont de simple bonus de stats a l'obtention de nouvelles armes pour equiper le personnage et le preparer a faire face aux hordes d'ennemis a venir.

Pour ce faire, j'ai creer un systeme de gestionnaire d'amelioration, qui cree a son tour un tableau de classe "Upgrade" qui ont chacunes leurs characteristiques distinctes et une rarete allant de 1 a 7. La classe "Upgrade" possede une methode appliquer pour appliquer ses stats au joueur en passant par un "Callable" qui appele la methode representant l'amelioration a appliquer.

Dans mon menu d'amelioration, le tableau de mon gestionnaire y est envoyer et melanger selon la rarete pour chaque niveau que le joueur a gagner durant la manche grace a la methode integree de godot max() qui recupere la plus haute valeur mais en comparant 1 et le plus haute rarete moins la rarete courante d'une amelioration, ca nous donne que plus la rarete de l'amelioration sera haute, moins le resultat de max sera haut. Ensuite, pour le resultat de max, on ajoute cette amelioration a un tableau. Maintenant nous pouvons melanger ce tableau et ne retourner que les 3 premiers resultats

![alt text](image.png)

    J'ai trouver cette technique en fouillant la doc officiele de godot 

    https://docs.godotengine.org/en/stable/classes/class_array.html
</br>



## Generation procedurale

Eye of the Toaster possede une map generee proceduralement, quoique ce n'est que visuel. Comme dans le jeu Vampire survivor, il me fallait une map assez grande pour pouvoir s'y promener quasiment a l'infini sans arriver a la fin.

Avec l'aide d'un Tilemap et du bruit de Perlin, au lieu de placer chaque tuile une par une et avoir une carte toujours pareil, nous avons un monde a l'allure plus naturelle qui ne sera jamais le meme entre chaque partie grace a la seed du bruit qui est generee aleatoirement a chaque partie

![alt text](image-1.png)

La maniere dont j'ai generer le bruit est soit noir ou blanc, pour chaque tuile ou le gazon devait aller, j'ai prit une tuile au hazard dans mon atlas parmis les tuiles representant du gazon et pareil pour les dalles.

    pour cet algorithme, je me suis aider de cette source 
    https://www.youtube.com/watch?v=rlUzizExe2Q
