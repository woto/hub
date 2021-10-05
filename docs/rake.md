# Rake commands
All the application's rake commands has scope `hub` and could be listed by: `rake -T hub`

```shell
woto@acer:~/work/hub$ rake -T hub
rake hub:elastic:clean  # Deletes all indexes
rake hub:feeds:sweep    # Sweep freezed feed's jobs
rake hub:tests:dirty    # Some test for dirty
rake hub:tests:graph    # First graph visualization
rake hub:tests:seed     # Seeds for testing in development
```