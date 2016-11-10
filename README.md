# Script Connect-IQ (Create/Build/Run)

### Install xmlstarlet
```go
brew install xmlstarlet

sudo apt-get install xmlstarlet
```

### Update PATH
```go
export CONNECTIQ_HOME=/usr/local/opt/connectiq-sdk-mac-2.1.5
export PATH=/opt/local/bin:/opt/local/sbin:$PATH:$CONNECTIQ_HOME/bin
```

### Create Connect-IQ Widget without Eclipse
```go
> ./create_widget.sh widgetName path
```

### Build Connect-IQ Widget
```go
> cd widgetName
> ./build.sh
```

### Run Connect-IQ Widget
```go
> cd widgetName
> ./run.sh
```
