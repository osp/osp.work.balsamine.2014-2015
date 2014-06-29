Épreuves avec 7 types de test, sur les 2 images, donc 14 pdf.

1. la sortie html de Ludi sans traitement
2. idem avec ajout de profil euroscale uncoated (adobe) par gs
3. idem avec profil munken print *
4. export scribus du tiff original d'hichem, avec ajout icc uncoated par scribus
5. idem sans ajout icc uncoated
6. export scribus du tiff mis au format et avec un sharpen 0,5-1,3 toujours avec ajout icc uncoated par scribus
7. idem avec en plus courbe pour contraster

* http://www.arcticpaper.com/en/Home/Arctic-Paper1/Arctic-Paper-ICC-Webb-Service/Download-profiles/

Sur les sorties pdf html, injecté le profil par
gs -sDEVICE=pdfwrite -dNOPAUSE -dQUIET -dBATCH -sOutputICCProfile=munken/AP_Munken_Print_White_260v4.1.icc -sOutputFile=avec-profil.pdf sans-profil.pdf

----

Résultat sur l'épreuve laser sur le Munken Print, garantie très proche par Dirk Gillis : 
- les 3 traitements GS sur le pdf html semblent identiques. Peut-être parce que les courbes sont très faibles, ou bien parce que ça ne marche pas?
- les Scribus pas très différents, sauf la version curve bien sur

----

Hichem décide pour sa version originale.
Je décide de ne pas passer par Scribus pour simplifier le traitement.

----

En Gimp, je sélectionne les couleurs sombres, avec un bord dégradé de 5px, et je mets du sharpen plus large 5px - 0,7 pour tenter d'attraper certains détails.
Pour compenser la manière dont le Munken Print va boire plus l'encre offset que l'encre laser en croute, j'applique une courbe légère, fichier 'curve2-original-hichem-compensated-laserproof-to-offset' à appliquer dans Curves.

Il faut dans l'html choisir les images traitées, puis injecter la courbe au pdf résultat, toujours avec 
gs -sDEVICE=pdfwrite -dNOPAUSE -dQUIET -dBATCH -sOutputICCProfile=munken/AP_Munken_Print_White_260v4.1.icc -sOutputFile=avec-profil.pdf sans-profil.pdf



Historique :

Le 26 juin 2014 00:34, Stéphanie Vilayphiou <stephanie@stdin.fr> a écrit :
> yes le profil gs, bien joué
> oui ça m'a l'air pareil, c'est vrai que les écrans contemporains sont très
> trompeurs selon où se trouve l'image dans l'écran et l'inclinaison de
> l'écran.
>
> si tu veux être sûre, tu peux tenter un compare avec imagemagick
> http://www.imagemagick.org/script/compare.php
>
> en tentant direct depuis les pdf:
> compare scribus.pdf html.pdf difference.png
>
> si ça ne marche pas, convertir le pdf en bitmap:
> compare scribus.jpg html.jpg difference.png
>
> mais logiquement, je ne vois pas de raison pour laquelle ce serait différent
> vu qu'il prend les mêmes informations de couleur.
> S.
>
>
>
> On 26/06/2014 00:08, Ludi wrote:
>>
>> un essai pour voir suivant la piste soufflée par Steph d'appliquer des
>> profils icc sur le pdf html via Ghostscript
>>
>> j'ai regardé ici
>> http://www.ghostscript.com/doc/9.07/GS9_Color_Management.pdf
>> j'ai pris les profils Adobe
>> http://download.adobe.com/pub/adobe/iccprofiles/win/AdobeICCProfiles.zip
>> et j'ai lancé ça
>>
>> gs -sOutputFile=check.pdf -sDEVICE=pdfwrite
>> -sDefaultCMYKProfile=EuroscaleCoated.icc -dNOPAUSE -dQUIET -dBATCH
>> criss-cross_html.pdf
>>
>> et donc là, j'ai les yeux trop délavés pour être sure mais oui à
>> l'écran la teinte des 2 images des pdf était un peu différente
>> ici sur la screenshot on dirait juste la même chose
