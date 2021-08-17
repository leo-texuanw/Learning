## Functions
```
funcExample () {
  # ...
}

funcExample
```

### Variable Scope
Local variable is assigned and becomes available in the caller after the function gets called.

### Functions with parameters
```
funcExample () {
  echo "The first parameter is $1..."
}

funcExample "param1"
```

### Nested Functions
```
GENDER=$1

createHuman () {
  ARMS=2
  LEGS=2

  male () {
    BEARD=1

    echo "This man has $ARM arms and $LEGS legs, with $BEARD beard..."
    echo ""
  }

  female () {
    BEARD=0

    echo "This woman has $ARM arms and $LEGS legs, with $BEARD beard..."
    echo ""
  }
}

clear
createHuman
if [ "$GERDER" == "male" ]; then
  male
else
  female
fi
```

### Function returns
```
YES=0
NO=1
FIRST=$1
SECOND=$2
THIRD=$3

checkParams () {
  # did we get 3
  if [ ! -z "$THIRD" ]; then
    echo "We got three params..."
    return $YES
  else
    echo "We did not get three params..."
    return $NO
  fi
}

checkParams
RET_VAL=$?

if [ "$RET_VAL" -eq "$YES" ]; then
  echo "We received three params..."
else
  echo "Usage: returnval.sh param1 param2 param3"
  exit 1
fi
```
