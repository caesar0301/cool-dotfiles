#!/bin/bash
JDK_HOME=${JAVA_HOME_4GJF}
if [ x$JDK_HOME == "x" ]; then
    JDK_HOME=${JAVA_HOME}
fi

JAVABIN="java"
if [ x$JDK_HOME != "x" ]; then
    JAVABIN=$JDK_HOME/bin/java
fi

GJFJAR="${GJF_JAR_FILE}"
if [ x$GJFJAR == "x" ]; then
    GJFJAR=$HOME/.local/share/google-java-format/google-java-format-all-deps.jar
fi

$JAVABIN -jar $GJFJAR $@
