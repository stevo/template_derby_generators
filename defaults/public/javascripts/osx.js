var OSX = {
		container: null,
		open: function (d) {
			var self = this;
			self.container = d.container[0];
			d.overlay.fadeIn(300, function () {
				$("#osx-modal-content", self.container).fadeIn();
				var title = $("#osx-modal-title", self.container);
				title.fadeIn();
				d.container.fadeIn(350, function () {

						var h = $("#osx-modal-data", self.container).height()
							+ title.height()
							+ 35; // padding
						d.container.animate(
							{height: h},
							200,
							function () {
								$("div.close", self.container).fadeIn();
								$("#osx-modal-data", self.container).fadeIn();
							}
						);

				});
			})
		},
		close: function (d) {
			var self = this;
            d.container.fadeOut( 300,
            function() {
                d.overlay.fadeOut(
                    300,
                    function () {
                        self.close(); // or $.modal.close();
                    }
                );
            }
            );
		}
	};



	function showModal() {
		$("#osx-modal-content").modal({
			overlayId: 'osx-overlay',
			containerId: 'osx-container',
			closeHTML: '<a href="#" class="bt_close"><img src="/images/icons/close.png" /></a>',
			minHeight:80,
			opacity:65, 
			position:['100px',],
			overlayClose:true,
			onOpen:OSX.open,
			onClose:OSX.close
		});
	}


/*
					setTimeout(function () {
						var h = $("#osx-modal-data", self.container).height()
							+ title.height()
							+ 20; // padding
						d.container.animate(
							{height: h},
							200,
							function () {
								$("div.close", self.container).show();
								$("#osx-modal-data", self.container).show();
							}
						);
					}, 300);        

        */