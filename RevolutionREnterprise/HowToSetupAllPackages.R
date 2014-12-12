
### 下載所有的包，包括已經安裝過的包，並安裝
pkgNames<- available.packages()[,1]
install.packages(pkgNames)


### 下載未安裝過的包的前置作業
havePkgs<-installed.packages()[,1]
names(havePkgs)<-NULL
downPkgs<-pkgnames[!is.element(pkgNames,havePkgs)]

#### 直接下載並安裝
install.packages(downPkgs)

#### 只下載壓縮檔，不進行安裝，Windows版本
download.packages(downPkgs,"D:/forWinSetupAllPackagesZip")

#### 只下載壓縮檔，不進行安裝，Linux版本
download.packages(downPkgs,"D:/forLinuxSetupAllPackagesTarGz")


