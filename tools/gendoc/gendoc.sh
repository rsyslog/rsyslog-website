# to turn on container debug mode, add this to the docker command below:
# -e DEBUG="on"
if [ "$DOC_HOME" == "" ]; then
	echo ERROR: DOC_HOME env var must be set!
	exit 1
fi
if [ "$WEB_PRJ_HOME" == "" ]; then
	echo ERROR: WEB_PRJ_HOME env var must be set!
	echo this is the home directory of github.com/rsyslog/rsyslog-website
	exit 1
fi
if [ "$SERVER_UPDATE_CMD" == "" ]; then
	echo ERROR: SERVER_UPDATE_CMD env var must be set!
	echo This must point to an executable command that updates the
	echo actual server. It gets one parameter, which is the branch
	echo to be updated.
	echo example call: /path/to/script/update-server v8-stable
	echo in this case, use
	echo export SERVER_UPDATE_CMD=/path/to/script/update-server
	exit 1
fi
echo "======starting doc generation======="
docker pull rsyslog/rsyslog_doc_gen_website # get fresh version
cd $DOC_HOME

for branch in v5-stable v7-stable v8-stable master;
do
	echo "**** $branch ****"
	rm -rf build
	git reset --hard
	git checkout -f $branch
	git pull

	docker run -ti --rm \
		-u `id -u`:`id -g` \
		-v "$DOC_HOME":/rsyslog-doc \
		-v "$WEB_PRJ_HOME/tools/gendoc/SPHINX_EXTRA_OPTS:/rsyslog-doc/SPHINX_EXTRA_OPTS" \
		-e STRICT="" \
		rsyslog/rsyslog_doc_gen_website
	$SERVER_UPDATE_CMD $branch
done
