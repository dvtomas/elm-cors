# Elm CORS Fail demo

Repository to just show off my failing CORS request.

This works:

```
 curl -k -i -H "Content-Type: application/json"\
 -H "x-apikey: 5d4edcc758a35b31adeba6a8"\
 -G 'https://fffuuu-c42f.restdb.io/rest/messages'
```

but this [Elm demo](https://dvtomas.github.io/elm-cors/) trying to do the same does not
