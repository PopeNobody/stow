package Nobody::Dumper;

use base "Exporter::Tiny";
require Data::Dumper;
push(@Data::Dumper::EXPORT,"qquote");
push(@Data::Dumper::EXPORT_OK,"qquote");
use Data::Dumper;
$Data::Dumper::Useqq=1;
$Data::Dumper::Deparse=1;
1;
