import React, { useCallback } from 'react';
import Button from '@material-ui/core/Button';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';
import {TextInput} from './index';

const FormDialog = () => {
  const [image, setImage] = useSate("");
  const [english, setEnglish]= useState("");
  const [japanese, setJapanese] = useState("");
  const [comment, setComment] = useState("");

  const inputImage = useCallback((event) => {
    setImage(event.target.value)
  }, [setImage]);

  const inputEnglish = useCallback((event) => {
    setEnglish(event.target.value)
  }, [setEnbglish]);

  const inputJapanese = useCallback((event) => {
    setJanpanese(event.target.value)
  }, [setJapanese]);

  const inputComment = useCallback((event) => {
    setComment(event.target.value)
  }, [setComment]);

  const [open, setOpen] = useState(false);

  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  return (
    <div>
      <Button variant="outlined" color="primary" onClick={handleClickOpen}>
        投稿する
      </Button>
      <Dialog
        open={open}
        onClose={handleClose}
        aria-labelledby="alert-dialog-title"
        aria-describedby="alert-dialog-description"
      >
        <DialogTitle id="alert-dialog-title">投稿フォーム</DialogTitle>
        <DialogContent>
          <TextInput
            label={"iamge"}　multiline={false} rows={1}
            value={naem} type={"text"} onChange={inputImage}
          />
          <TextInput
            label={"english"}　multiline={false} rows={1}
            value={naem} type={"text"} onChange={inputEnglish}
          />
          <TextInput
            label={"japanese"}　multiline={false} rows={1}
            value={naem} type={"text"} onChange={inputJapanese}
          />
          <TextInput
            label={"comment"}　multiline={false} rows={3}
            value={naem} type={"text"} onChange={inputComment}
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={handleClose} color="primary">
            キャンセル
          </Button>
          <Button onClick={handleClose} color="primary" autoFocus>
            送信
          </Button>
        </DialogActions>
      </Dialog>
    </div>
  );
}

export default FormDialog