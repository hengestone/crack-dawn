#include <stdlib.h>
#include <stdio.h>
#include <mongo.h>

void tut_sync_query_simple (void) {
  mongo_sync_connection *conn;
  mongo_packet *p;
  mongo_sync_cursor *cursor;
  bson *query;
  gint i = 0;

  conn = mongo_sync_connect ("localhost", 27017, FALSE);
  if (!conn) {
    perror ("mongo_sync_connect()");
    exit (1);
  }

  query = bson_new ();
  bson_finish (query);

  p = mongo_sync_cmd_query (conn, "dawn.test", 0, 0, 10, query, NULL);
  if (!p)
  {
  perror ("mongo_sync_cmd_query()");
  exit (1);
  }
  bson_free (query);

  cursor = mongo_sync_cursor_new (conn, "tutorial.docs", p);
  if (!cursor) {
    perror ("mongo_sync_cursor_new()");
    exit (1);
  }

  while (mongo_sync_cursor_next (cursor)) {
    bson *result = mongo_sync_cursor_get_data (cursor);
    bson_cursor *c;
    if (!result) {
      perror ("mongo_sync_cursor_get_data()");
      exit (1);
    }
    printf ("Keys in document #%d:\n", i);
    c = bson_cursor_new (result);
    while (bson_cursor_next (c))
    printf ("\t%s\n", bson_cursor_key (c));

    i++;
    bson_cursor_free (c);
    bson_free (result);
  }
  mongo_sync_cursor_free (cursor);
  mongo_sync_disconnect (conn);
}

int main(int argc, char **argv) {
  tut_sync_query_simple();
  return 0;
}
