 status

 draft:    <- nil, rejected, pending

 pending:  <- nil, draft, rejected

 accrued:  <- pending

 rejected: <- pending

 canceled: <- accrued


                      approved -> accrued -> canceled
                    /
    draft -> pending 
               |     \
               |     rejected
               |              \
                \             /
                  -----------
