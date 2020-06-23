(function($) {

	"use strict";

	var fullHeight = function() {

		$('.js-fullheight').css('height', $(window).height());
		$(window).resize(function(){
			$('.js-fullheight').css('height', $(window).height());
		});

	};
	fullHeight();

	$('#sidebarCollapse').on('click', function () {
      $('#sidebar').toggleClass('active');
  });

  var url = window.location.href;
  var reg=/[a-z]*.html$/;
  var res=reg.exec(url);
  
  
  if(res[0]==='vlasnistvo.html' || res[0]==='vu.html'|| res[0]==='drzava.html'|| res[0]==='tip.html'){

  $( "nav#sidebar" ).append(`
  <div class="p-4 pt-5">
    <a href="#" class="img logo rounded-circle mb-5" style="background-image: url(images/logo.jpg);"></a>
    <ul class="list-unstyled components mb-5">
        <li class="active"> <a href="#homeSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">MySQL</a>
            <ul class="collapse list-unstyled show" id="homeSubmenu">
                <li> <a href="vu.html">Visokoškolska ustanova</a></li>
                <li> <a href="drzava.html">Država</a></li>
                <li> <a href="vlasnistvo.html">Vrsta vlasništva</a></li>
                <li> <a href="tip.html">Tip ustanove</a></li>
            </ul>
        </li>
        <li> <a href="#pageSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">MongoDB</a>
            <ul class="collapse list-unstyled" id="pageSubmenu">
                <li> <a href="doc1.html">Visokoškolske ustanove u okviru jedne države</a></li>
                <li> <a href="doc2.html">Visokoškolske ustanove po tipu vlasništva </a></li>
                <li> <a href="doc3.html">Visokoškolske ustanove po tipu ustanove</a></li>
            </ul>
        </li>

        <li>
        <a href="graf.html">Graf</a>
        </li>
       
    </ul>
</div>
  `);}else{

    $( "nav#sidebar" ).append(`
    <div class="p-4 pt-5">
      <a href="#" class="img logo rounded-circle mb-5" style="background-image: url(images/logo.jpg);"></a>
      <ul class="list-unstyled components mb-5">
          <li class="active"> <a href="#homeSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">MySQL</a>
              <ul class="collapse list-unstyled" id="homeSubmenu">
                  <li> <a href="vu.html">Visokoškolska ustanova</a></li>
                  <li> <a href="drzava.html">Država</a></li>
                  <li> <a href="vlasnistvo.html">Vrsta vlasništva</a></li>
                  <li> <a href="tip.html">Tip ustanove</a></li>
              </ul>
          </li>
          <li> <a href="#pageSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">MongoDB</a>
              <ul class="collapse list-unstyled show" id="pageSubmenu">
                  <li> <a href="doc1.html">Visokoškolske ustanove u okviru jedne države</a></li>
                  <li> <a href="doc2.html">Visokoškolske ustanove po tipu vlasništva </a></li>
                  <li> <a href="doc3.html">Visokoškolske ustanove po tipu ustanove</a></li>
              </ul>
          </li>

          <li>
        <a href="graf.html">Graf</a>
        </li>
         
      </ul>
  </div>
    `);




  }

})(jQuery);


/* <li> <a href="#graphSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">Neo4j</a>
            <ul class="collapse list-unstyled" id="graphSubmenu">
                <li> <a href="#">Graf 1</a></li>
                <li> <a href="#">Graf 2</a></li>
                <li> <a href="#">Graf 3</a></li>
            </ul>
        </li>*/