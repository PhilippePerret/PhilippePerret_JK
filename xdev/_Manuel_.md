# Manuel d'utilisation pour le site perso<br>Rédaction des pages et programmation



[Section programmation](#programmation)



## Constantes site

On peut insérer des constantes définies dans le fichier de configuration `_config.yml` très simplement et utiliser la balise `{{ site.constantes.ma_constante }}` (noter les doubles crochets).

Dans le fichier `_config.yml`, la constante doit être définie ainsi :

~~~yaml

...

constantes:
  ma_constante: Ceci est ma constante

~~~

Ci-dessus, `constantes` n'est pas du tout un mot réservé, on peut mettre ce qu'on veut et faire par exemple :

~~~yaml
# dans _config.yml

mes_trucs_a_moi:
  mon_premier: C’est mon premier truc
  mon_deuxieme: C’est mon deuxième truc

~~~

Et utiliser ensuite, dans le texte, `{{ site.mes_trucs_a_moi.mon_premier }}` ou  `{{ site.mes_trucs_a_moi.mon_deuxieme }}`.

## Toutes les balises utilisables

* [`{% date <date> %}`](#tag_date). Pour inscrire une date dans un format de date propre. Permet aussi de convertir une date ou un timestamp en date humaine.
* `{% exergue <texte>%}`. Permet de mettre le `<texte>` dans le style exergue, c'est-à-dire en rouge gras, sur le site perso.
* [`{% image <path> <class> <legend> %}`](#tag_image). Permet d'insérer une image. L'avantage, par rapport au tag normal du markdown, c'est que la tag peut créer une source (`src`) complète d'après un dossier image précisé dans la page.
* [`{% lien <id-lien> %}`](#lien_tag). Permet d’insérer un lien fréquent par son identifiant de lien. Par exemple `{% lien cloaca-maxima %}` pour rejoindre l’article qui parle du livre
* [`{% youtube <youtube-id> <class> <legend> %}`](#video_tag). Insère une vidéo Youtube. Les paramètres sont les mêmes que pour [les images](#tag_image)

<a id="tag_date"></a>

## Tag `date`

Syntaxe :

~~~markdown

{% date[ <date>] %}

~~~

Exemples :

~~~markdown

{% date 28 novembre 2020 %}

On est aujourd'hui le {% date %}.

Le 28 novembre, on était le {% date 2020/11/28 %}.
~~~

<a id="tag_image"></a>

## Images

On peut insérer les images très facilement à l'aide du helper de tag `image` :

~~~markdown

{% image image.jpg class_css Une légende pour l'image %}

<!-- Ou une image simple sans légende -->

{% image image.jpg sa_class %}

~~~

> Mettre la classe à 'none' ou 'nil' pour ne pas en mettre (quand on veut indiquer une légende.

Si l'image se trouve dans un sous-dossier de `./img`, ce sous-dossier peut être mentionné dans le front-matter de la page à l'aide de la donnée `dossier_images`. Page complète :

~~~markdown
---
titre: Un titre de page
dossier_images: articles/mon-dossier
---

{% image image.jpg class_css Une image avec légende qui se trouve dans le dossier ./img/articles/mon-dossier/ %}

~~~



<a id="lien_tag"></a>

## Tag `lien`

Usage :

~~~
{% lien <id-lien>[ <titre lien>|alt] %}
~~~

Où :

~~~
<id-lien> doit être défini dans le fichier '_data/liens.yml' par son titre et sa location (emplacement)
~~~

Soit le lien défini :

~~~YAML
# _data/liens.yml

mon-lien:
	location: _articles/mon-article.md
	titre_alt: "un autre titre si 'alt' est utilisé"
~~~

Soit la page :

~~~markdown
---
titre: Le titre de l'article
permalink: /arts/tout-mon-art-ticle
~~~

Alors le texte :

~~~markdown
Ceci est {% lien mon-lien %}.
~~~

… produira :

~~~html
<p>Ceci est <a href="/arts/tout-mon-art-ticle">Le titre de l'article</a>.</p>
~~~

Tandis que le texte :

~~~markdown
Ceci est {% lien mon-lien alt %}.
~~~

… produira :

~~~html
<p>Ceci est <a href="/arts/tout-mon-art-ticle">un autre titre si 'alt' est utilisé</a>.</p>
~~~

Et enfin le texte :

~~~markdown
Ceci est {% lien mon-lien avec un titre propre %}.
~~~

… produira :

~~~html
<p>Ceci est <a href="/arts/tout-mon-art-ticle">avec un titre propre</a>.</p>
~~~



<a id="video_tag"></a>

### Tag vidéo

Usage

~~~markdown
{% youtube <video-id> <class> <legend> %}
~~~

La `class`et la `legend`, comme pour les [images](#tag_image), sont facultatifs.







---



<a id="programmation"></a>

## Programmation

Cette section concerne la programmation proprement dite du site personnel Jekyll.