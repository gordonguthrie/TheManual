
# The Manual

## Writing Super Collider Synthesisers For Sonic Pi

## Gordon Guthrie

```
 __          __        _      _____
 \ \        / /       | |    |_   _|
  \ \  /\  / /__  _ __| | __   | |  _ __
   \ \/  \/ / _ \| '__| |/ /   | | | '_ \
    \  /\  / (_) | |  |   <   _| |_| | | |
  ___\/  \/ \___/|_|  |_|\_\ |_____|_| |_|
 |  __ \
 | |__) | __ ___   __ _ _ __ ___  ___ ___
 |  ___/ '__/ _ \ / _` | '__/ _ \/ __/ __|
 | |   | | | (_) | (_| | | |  __/\__ \__ \
 |_|   |_|  \___/ \__, |_|  \___||___/___/
                   __/ |
                  |___/
```


 <div>
 {% for item in site.data.contents.toc %}
     <h3>{{ item.title }}</h3>
       <ul>
         {% for entry in item.subfolderitems %}
           <li><a href="{{ entry.url }}">{{ entry.page }}</a></li>
         {% endfor %}
       </ul>
   {% endfor %}
 </div>
