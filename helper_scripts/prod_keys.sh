#!/bin/bash
keytool -list -v \
  -keystore /Users/dt/Desktop/DT/fvf_flutter/upload-keystore.jks \
  -alias upload \
  -storepass com.slay.org.app \
  -keypass com.slay.org.app
