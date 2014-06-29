J'ai finalement produit 7 types de test, sur les 2 images, donc 14 pdf.
1. la sortie html de Ludi sans traitement
2. idem avec ajout de profil euroscale uncoated (adobe) par gs
3. idem avec profil munken print *
4. export scribus du tiff original d'hichem, avec ajout icc uncoated par scribus
5. idem sans ajout icc uncoated
6. export scribus du tiff mis au format et avec un sharpen 0,5-1,3 toujours avec ajout icc uncoated par scribus
7. idem avec en plus courbe pour contraster

Je push ce qui n'est pas trop lourd avec petit readme.

* http://www.arcticpaper.com/en/Home/Arctic-Paper1/Arctic-Paper-ICC-Webb-Service/Download-profiles/
gs -sDEVICE=pdfwrite -dNOPAUSE -dQUIET -dBATCH -sOutputICCProfile=AP_Munken_Print_White_260v4.1.icc -sOutputFile=bleu_html_munkenprint.pdf bleu_html.pdf

C'est en train de passer vers Dirk. 
Inch'Allah.

Pierre



2014-06-26 0:44 GMT+02:00 Ludi <hello@ludi.be>:
oho
sur cette constellation rouge, je file au lit



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
