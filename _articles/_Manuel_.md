## Images

On peut insérer les images très facilement à l'aide du helper de tag `image` :

~~~markdown

{% image image.jpg class_css Une légende pour l'image %}

<!-- Ou une image simple sans légende -->

{% image image.jpg sa_class %}

~~~

Si l'image se trouve dans un sous-dossier de `./img`, ce sous-dossier peut être mentionné dans le front-matter de la page à l'aide de la donnée `dossier_images`. Page complète :

~~~markdown
---
titre: Un titre de page
dossier_images: articles/mon-dossier
~~~

{% image image.jpg class_css Une image avec légende qui se trouve dans le dossier ./img/articles/mon-dossier/ %}
