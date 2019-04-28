#!/bin/bash

# MIT LICENSE
# Copyright 2019 Caleb Jones <calebjones@gmail.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining 
# a copy of this software and associated documentation files 
# (the "Software"), to deal in the Software without restriction, including 
# without limitation the rights to use, copy, modify, merge, publish, 
# distribute, sublicense, and/or sell copies of the Software, and to permit 
# persons to whom the Software is furnished to do so, subject to the 
# following conditions:
# 
# The above copyright notice and this permission notice shall be included in 
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

##################################################
# BASIC PARAMETERS - CHANGE TO YOUR AUTHOR EMAIL #
##################################################
AUTHOR="you@email.com"

# A BASH SCRIPT FOR BASIC ENML NOTE RECOVERY. USEFUL IN CASE WHEN 
# EVERNOTE DATABASE CORRUPTION MAKES EXPORT IMPOSSIBLE AND LOCAL
# NOTEBOOK RECOVERY IS NECESSARY. USEFUL WHEN ENCOUNTERING THE 
# 'An internal database error has occurred that prevents Evernote 
# from functioning properly." ERROR WHEN YOU HAVE LOCAL-ONLY 
# NOTEBOOKS.

# TO USE, RUN 'recover-evernote-enml.sh > file.enex' THEN IMPORT
# 'file.enex' INTO EVERNOTE. NOTES WILL HAVE A RANDOM UUID FOR TITLE,
# AND SHOULD CONTAIN NOTES ACROSS ALL JOURNALS (ONLINE OR 
# LOCAL-ONLY). USER WILL NEED TO DETERMINE THEMSELVES (BASED ON 
# NOTE CONTENT) WHICH NOTES TO RECOVER ONCE IMPORTED. DEPENDING ON 
# NUMBER OF NOTES, THIS EXPORT PROCESS MAY TAKE SOME TIME. WATCH THE
# 'file.enex' FILE (FROM ABOVE) WHICH WILL CONTINUOUSLY GROW AS THE 
# EXPORT RUNS.

# NOTE, FOLLOW EVERNOTE'S INSTRUCTIONS FOR RECOVERYING THE APP
# FUNCTIONALITY WHEN DATABASE IS CORRUPTED WHICH MAY PREVENT 
# EVERNOTE FROM OPENING. THIS MAY BE NECESSARY BEFORE IMPORT IS 
# POSSIBLE. NOTE, EVERNOTE'S INSTRUCTIONS MAY REQUIRE DELETING ENML
# FILES THIS SCRIPT USES TO RECOVER NOTES FROM. THIS SCRIPT SHOULD BE
# RUN BEFORE ANY DESTRUCTIVE ACTION IS TAKEN ON EVERNOTE FILES ON DISK.
# IT IS LIKELY BEST TO MAKE A FULL BACKUP OF EVERNOTE FILES BEFORE
# TAKING ANY DESTRUCTIVE ACTION ON FILES. THIS SCRIPT CAN RECOVER FROM
# ENML FILES FROM ANY LOCATION BY CONFIGURING THE 'FIND_LOCATION' 
# PARAMETER BELOW.

# THIS SCRIPT WAS CREATED AND TESTED ON OSX '10.13.6' WITH EVERNOTE 
# VERSION '7.9.1 (457700 Direct)'.

#######################################################
# GENERAL PARAMETERS (LIKEY DON'T NEED TO BE CHANGED, #
# BUT MAY BE IF YOU KNOW WHAT YOU'RE DOING)           #
#######################################################
HOST_UUID=`uuidgen`
RECOVERY_SOURCE_APP_NAME="desktop.mac"
FIND_LOCATION=~/'Library/Application Support/com.evernote.Evernote/accounts/www.evernote.com'
FIND_FILE_PATTERN='content.enml'


#####################################################################
# CODE FOR RECOVERY (CHANGE IF YOU *REALLY* KNOW WHAT YOU'RE DOING) #
#####################################################################

script_time=`date +"%Y%m%dT%H%M%SZ"`

ENEX_HEADER="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE en-export SYSTEM \"http://xml.evernote.com/pub/evernote-export3.dtd\">
<en-export export-date=\"${script_time}\" application=\"Evernote\" version=\"Evernote Mac 7.8 (457453)\">"

echo "$ENEX_HEADER"

find "${FIND_LOCATION}" -type f -name $FIND_FILE_PATTERN -print0 | 
while IFS= read -r -d '' file; do
	# read enml file contents
	file_data=`cat "$file"`
	
	# escape internal CDATA - this could be generalized more
	file_data=${file_data//<\!\[CDATA\[>\]\]>/<\![CDATA[>]]]]><\![CDATA[>}
	
	# can't recover the title/date from the enml file - just use random UUID
	# TODO: maybe get note date from enml file date?
	note_uuid=`uuidgen`
	note_time=`date +"%Y%m%dT%H%M%SZ"`
	
	# wrap enml file contents in <note> XML
	ENEX_NOTE_TEMPLATE="<note><title>${note_uuid}</title><content><![CDATA[${file_data}]]></content><created>${note_time}</created><updated>${note_time}</updated><note-attributes><author>${AUTHOR}</author><source>${RECOVERY_SOURCE_APP_NAME}</source><reminder-order>0</reminder-order><application-data key=\"corenote-localUUID\">${note_uuid}</application-data><application-data key=\"corenote-hostUUID\">${HOST_UUID}</application-data></note-attributes></note>"
	
	echo "$ENEX_NOTE_TEMPLATE"
done


ENEX_FOOTER='</en-export>'

echo "$ENEX_FOOTER"
