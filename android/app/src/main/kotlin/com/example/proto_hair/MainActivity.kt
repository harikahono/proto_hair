package com.example.proto_hair

import android.Manifest
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.media.Image
import android.os.Bundle
import android.util.Size
import android.view.SurfaceHolder
import android.view.SurfaceView
import androidx.camera.core.CameraSelector
import androidx.camera.core.ImageAnalysis
import androidx.camera.core.ImageProxy
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.lifecycle.LifecycleOwner
import ai.deepar.ar.DeepAR
import ai.deepar.ar.AREventListener
import ai.deepar.ar.ARErrorType
import ai.deepar.ar.DeepARImageFormat
import ai.deepar.ar.CameraResolutionPreset
import com.google.common.util.concurrent.ListenableFuture
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.util.concurrent.ExecutionException

class MainActivity : FlutterActivity(), AREventListener {

    private lateinit var deepAR: DeepAR
    private lateinit var surfaceView: SurfaceView
    private lateinit var cameraProviderFuture: ListenableFuture<ProcessCameraProvider>

    private val CHANNEL = "deepar_channel"
    private val CAMERA_PERMISSION_REQUEST = 1001
    private var buffers: Array<ByteBuffer?> = arrayOfNulls(2)
    private var currentBuffer = 0
    private val lensFacing = CameraSelector.LENS_FACING_FRONT

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        surfaceView = SurfaceView(this)
        setContentView(surfaceView)

        deepAR = DeepAR(this)
        deepAR.setLicenseKey("000e8a0cfeb2e23800585f126bb7560abd60277ef767f238466e17425e5afd3a7a40e40a2b25dc2d")
        deepAR.setAREventListener(this)
        deepAR.initialize(this, this)

        surfaceView.holder.addCallback(object : SurfaceHolder.Callback {
            override fun surfaceCreated(holder: SurfaceHolder) {}
            override fun surfaceChanged(holder: SurfaceHolder, format: Int, width: Int, height: Int) {
                deepAR.setRenderSurface(holder.surface, width, height)
            }
            override fun surfaceDestroyed(holder: SurfaceHolder) {
                deepAR.setRenderSurface(null, 0, 0)
            }
        })

        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA)
            != PackageManager.PERMISSION_GRANTED
        ) {
            ActivityCompat.requestPermissions(
                this,
                arrayOf(Manifest.permission.CAMERA),
                CAMERA_PERMISSION_REQUEST
            )
        } else {
            setupCamera()
        }

        // Flutter method channel
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startAR" -> {
                        setupCamera()
                        result.success("AR started")
                    }
                    "changeHairColor" -> {
                        val color = call.argument<String>("color") ?: "red"
                        deepAR.switchEffect("effect", "file:///android_asset/effects/$color.deepar")
                        result.success("Changed to $color")
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun setupCamera() {
        cameraProviderFuture = ProcessCameraProvider.getInstance(this)
        cameraProviderFuture.addListener({
            try {
                val cameraProvider = cameraProviderFuture.get()
                val cameraSelector = CameraSelector.Builder()
                    .requireLensFacing(lensFacing)
                    .build()

                val resolutionPreset = CameraResolutionPreset.P1280x720
                val width = resolutionPreset.width
                val height = resolutionPreset.height

                buffers[0] = ByteBuffer.allocateDirect(width * height * 4).order(ByteOrder.nativeOrder())
                buffers[1] = ByteBuffer.allocateDirect(width * height * 4).order(ByteOrder.nativeOrder())

                val imageAnalysis = ImageAnalysis.Builder()
                    .setTargetResolution(Size(width, height))
                    .setOutputImageFormat(ImageAnalysis.OUTPUT_IMAGE_FORMAT_RGBA_8888)
                    .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
                    .build()

                imageAnalysis.setAnalyzer(ContextCompat.getMainExecutor(this)) { imageProxy ->
                    analyzeFrame(imageProxy)
                }

                cameraProvider.unbindAll()
                cameraProvider.bindToLifecycle(this as LifecycleOwner, cameraSelector, imageAnalysis)

            } catch (e: ExecutionException) {
                e.printStackTrace()
            } catch (e: InterruptedException) {
                e.printStackTrace()
            }
        }, ContextCompat.getMainExecutor(this))
    }

    private fun analyzeFrame(image: ImageProxy) {
        val buffer = image.planes[0].buffer
        buffer.rewind()

        val width = image.width
        val height = image.height
        val requiredCapacity = width * height * 4

        // Pastikan buffer cukup besar
        if (buffers[currentBuffer] == null || buffers[currentBuffer]!!.capacity() < requiredCapacity) {
            buffers[currentBuffer] = ByteBuffer.allocateDirect(requiredCapacity).order(ByteOrder.nativeOrder())
        }

        val targetBuffer = buffers[currentBuffer]!!
        targetBuffer.clear()
        targetBuffer.put(buffer)
        targetBuffer.position(0)

        deepAR.receiveFrame(
            targetBuffer,
            width,
            height,
            image.imageInfo.rotationDegrees,
            lensFacing == CameraSelector.LENS_FACING_FRONT,
            DeepARImageFormat.RGBA_8888,
            image.planes[0].pixelStride
        )

        currentBuffer = (currentBuffer + 1) % 2
        image.close()
    }

    override fun onDestroy() {
        super.onDestroy()
        deepAR.release()
    }

    // ------------------------------------------------------
    // DeepAR Event callbacks
    // ------------------------------------------------------
    override fun initialized() {
        deepAR.switchEffect("effect", null as String?)
    }

    override fun screenshotTaken(bitmap: Bitmap?) {}
    override fun videoRecordingStarted() {}
    override fun videoRecordingFinished() {}
    override fun videoRecordingFailed() {}
    override fun videoRecordingPrepared() {}
    override fun shutdownFinished() {}
    override fun faceVisibilityChanged(b: Boolean) {}
    override fun imageVisibilityChanged(s: String?, b: Boolean) {}
    override fun frameAvailable(image: Image?) {}
    override fun error(arErrorType: ARErrorType?, s: String?) {}
    override fun effectSwitched(s: String?) {}
}
