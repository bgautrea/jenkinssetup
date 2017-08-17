#!/bin/bash
kill `ps -ef | grep [j]enkins.war | awk '{ print $2 }'`
