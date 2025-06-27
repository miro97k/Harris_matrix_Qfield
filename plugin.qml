import QtQuick 2.15
import QtQuick.Controls 2.15
import org.qfield 1.0

Item {
  Component.onCompleted: {
    let button = Qt.createQmlObject(`
      import QtQuick.Controls 2.15
      Button {
        text: "Harris Matrix"
        onClicked: root.showMatrix()
      }
    `, iface.mainWindow().contentItem);

    iface.addItemToCanvasActionsToolbar(button);
  }

  function showMatrix() {
    const layerNames = [
      "copre", "riempie", "taglia", "si_appoggia", "si_lega_a", "uguale_a"
    ];

    let edges = [];

    for (let i = 0; i < layerNames.length; i++) {
      let layer = iface.layerByName(layerNames[i]);
      if (!layer) continue;

      for (let f = 0; f < layer.featureCount; f++) {
        let feat = layer.feature(f);
        let from = feat["US_n"];
        let to = feat["us_rapporto"];

        if (from && to) {
          edges.push(from + " → " + to);
        }
      }
    }

    if (edges.length === 0) {
      iface.mainWindow().displayToast("Nessun rapporto trovato");
      return;
    }

    let output = "Matrice di Harris:\n\n" + edges.join("\n");

    Qt.createQmlObject(`
      import QtQuick 2.15
      import QtQuick.Controls 2.15
      Dialog {
        id: harrisDialog
        modal: true
        width: 400
        title: "Harris Matrix"
        standardButtons: Dialog.Ok
        TextArea {
          anchors.fill: parent
          readOnly: true
          text: \`${output}\`
        }
      }
    `, iface.mainWindow().contentItem).open();
  }
}
