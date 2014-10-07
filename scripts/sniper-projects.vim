" c-cshift
au BufRead,BufNewFile /home/cloud/cshift/compcore/src/*.h imap <buffer> \p cshift_compcore_
au BufRead,BufNewFile /home/cloud/cshift/compcore/src/*.c imap <buffer> \p cshift_compcore_
au BufRead,BufNewFile /home/cloud/cshift/compcore/src/*.h imap <buffer> \c CSHIFT_COMPCORE_CONST
au BufRead,BufNewFile /home/cloud/cshift/compcore/src/*.c imap <buffer> \c CSHIFT_COMPCORE_CONST
