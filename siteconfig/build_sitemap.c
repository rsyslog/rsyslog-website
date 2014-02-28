/* needs to receive a list of filenames under the /doc/ tree,
 * build static sitemap out of it.
 */
#include <stdio.h>

int main(int argc, char *argv[])
{
	char urlpart[1024];
	
	printf("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
	printf("<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n");

	while(gets(urlpart)) {
		printf(	"<url>"
			"<loc>http://www.rsyslog.com/doc/%s</loc>"
			"</url>\n", urlpart);
	}
	printf("</urlset>\n");
	return 0;
}
