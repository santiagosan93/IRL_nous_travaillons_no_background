

const initSweetAlert = () => {
  const errorsMade = document.getElementById('errors-made')
  if (errorsMade) {
    const errors =  JSON.parse(errorsMade.dataset.errors)
    console.log(errors)
    swal({
      title: "Ups, something went wrong",
      text: errors.join('.\n \n'),
      icon: "error",
    });
  }
};

export default initSweetAlert
