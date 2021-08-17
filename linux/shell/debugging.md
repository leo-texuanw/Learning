## Debugging
### Debugging the entire script
```
bash -x shellFile.sh
```

### Debugging a section
```
set -x  # Start debugging

# Scripts in between...

set +x  # Stop debugging
```
