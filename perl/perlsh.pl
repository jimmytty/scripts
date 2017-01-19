#!/usr/bin/env perl
exec q{perl \
           -MData::Dumper \
           -MURI::URL \
           -MURI::QueryParam \
           -MURI::Escape \
           -MHTML::Entities \
           -MList::Util=first,max,maxstr,min,minstr,reduce,shuffle,sum \
           -MScalar::Util=blessed,dualvar,isvstring,isweak,looks_like_number,readonly,refaddr,reftype,set_prototype,tainted,weaken \
           -MArchive::Extract \
           -MDigest \
           -MDigest::file=digest_file_hex \
           -MFile::Spec::Functions \
           -dwE0
     };
