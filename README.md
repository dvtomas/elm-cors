# Elm CORS Fail demo

Repository to just show off my failing CORS request.

This works:

```
 curl -k -i -H "Content-Type: application/json"\
 -H "x-apikey: 12745cc133246d659d53960af2463940e69d7"\
 -G 'https://fffuuu-c42f.restdb.io/rest/messages'
```

but this [Elm demo](https://dvtomas.github.io/elm-cors/) trying to do the same does not
